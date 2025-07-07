DO
$$
DECLARE
    tbl RECORD;
    col RECORD;

    audit_table_name text;
    audit_function_name text;
    audit_trigger_name text;

    encrypted_table_name text;
    encrypted_function_name text;
    encrypted_trigger_name text;

    schema_name text;
    pk_columns text[];
    audit_table_exists bool;
    encrypt_select text;
    decrypt_select text;

    current_column_defs text;
    audit_column_defs text;
    encrypted_column_defs text;

    insert_columns text;
    insert_values_new text;
    insert_values_old text;
    update_assignments text;
    pk_conditions text;
BEGIN
    -- Loop through all tables in the database 
    FOR tbl IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE'
            AND table_schema NOT IN ('pg_catalog', 'information_schema') -- exclude system tables
            AND table_name NOT LIKE '%_audit'     -- exclude audit tables
            AND table_name NOT LIKE '%_encrypted' -- exclude encrypted tables 
            AND table_name NOT LIKE '%_encrypted' -- exclude encrypted tables 

    LOOP
        -- Define audit & encrypted table, trigger, and function names
        schema_name := tbl.table_schema;
        audit_table_name    := tbl.table_name || '_audit';
        audit_function_name := tbl.table_name || '_audit_trigger_fn';
        audit_trigger_name  := tbl.table_name || '_audit_trigger';

        encrypted_table_name    := tbl.table_name || '_encrypted';
        encrypted_function_name := tbl.table_name || '_encrypted_trigger_fn';
        encrypted_trigger_name  := tbl.table_name || '_encrypted_trigger';

        -- Check if audit table exists
        SELECT EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = schema_name
              AND table_name = audit_table_name
        ) INTO audit_table_exists;	
				
        IF audit_table_exists THEN
			EXECUTE format('DROP TABLE %I.%I', schema_name, audit_table_name);
		END IF;

        -- Find the primary keys in each table
        SELECT ARRAY_AGG(kcu.column_name)
        INTO pk_columns
        FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
            AND tc.table_name = kcu.table_name
        WHERE tc.table_schema = tbl.table_schema
            AND tc.table_name = tbl.table_name
            AND tc.constraint_type = 'PRIMARY KEY';
        
        -- Build the column definitions for audit table by copying from base table
        current_column_defs   := '';
        audit_column_defs     := '';
        encrypted_column_defs := '';
        encrypt_select := '';
        decrypt_select := '';

	    FOR col IN
	        SELECT column_name, 
                data_type, 
                udt_name, 
                character_maximum_length, 
                numeric_precision, 
                numeric_scale
	        FROM information_schema.columns
	        WHERE table_schema = schema_name
	            AND table_name = tbl.table_name
	        ORDER BY ordinal_position
		LOOP
            current_column_defs :=  format('%I %s%s, ',
	            col.column_name,
	            -- Map information_schema data_type to PostgreSQL data types with length/precision
	            CASE
	                WHEN col.data_type = 'character varying' THEN
						CASE 
							WHEN col.character_maximum_length IS NULL  THEN format('VARCHAR')
							ELSE format('VARCHAR(%s)', col.character_maximum_length)
						END
	                WHEN col.data_type = 'character' THEN format('CHAR(%s)', col.character_maximum_length)
	                WHEN col.data_type = 'numeric' THEN
	                    CASE
	                        WHEN col.numeric_precision IS NULL THEN 'NUMERIC'
	                        WHEN col.numeric_scale IS NULL THEN format('NUMERIC(%s)', col.numeric_precision)
	                        ELSE format('NUMERIC(%s,%s)', col.numeric_precision, col.numeric_scale)
	                    END
					WHEN col.data_type = 'USER-DEFINED' THEN format('%s', col.udt_name)
	                ELSE col.data_type
	            END,
	            ''
	        );
            audit_column_defs := audit_column_defs || current_column_defs;

            IF pk_columns IS NOT NULL AND col.column_name = ANY(pk_columns) THEN
                encrypted_column_defs := encrypted_column_defs || current_column_defs;
                encrypt_select := encrypt_select || format('%I, ', col.column_name);
                decrypt_select := decrypt_select || format('%I, ', col.column_name);
            ELSE
                encrypted_column_defs := encrypted_column_defs || format('%I BYTEA, ', col.column_name);
                encrypt_select := encrypt_select || format(
                    'pgp_sym_encrypt(%I::text, ''BismillahSidangNilaiA''), ', col.column_name);
                decrypt_select := decrypt_select || format(
                    'pgp_sym_decrypt(%I, ''BismillahSidangNilaiA'')::%s AS %I, ',
                    col.column_name, 
                    CASE
                        WHEN col.data_type = 'USER-DEFINED' THEN col.udt_name
                        ELSE col.data_type
                    END,
                    col.column_name);
            END IF;
	    END LOOP;        

        -- Trim trailing commas
        encrypt_select := left(encrypt_select, length(encrypt_select) - 2);
        decrypt_select := left(decrypt_select, length(decrypt_select) - 2);
        encrypted_column_defs := left(encrypted_column_defs, length(encrypted_column_defs) - 2);

        -- Drop old encrypted table if exists
        EXECUTE format('DROP TABLE IF EXISTS %I.%I CASCADE', tbl.table_schema, encrypted_table_name);

        -- Create encrypted table with built columns
        EXECUTE format('CREATE TABLE IF NOT EXISTS %I.%I (%s)', tbl.table_schema, encrypted_table_name, encrypted_column_defs);

        RAISE NOTICE 'Created encrypted table %.%', tbl.table_schema, encrypted_table_name;

	    -- Add audit columns at the end
	    audit_column_defs := audit_column_defs || 'changed_by UUID NOT NULL, user_ip TEXT, action VARCHAR(10) NOT NULL, changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP';

	    -- Create audit table
	    EXECUTE format('CREATE TABLE %I.%I (%s)', schema_name, audit_table_name, audit_column_defs);

        -- Drop existing trigger/function if any
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I', audit_trigger_name, schema_name, encrypted_table_name);
        EXECUTE format('DROP FUNCTION IF EXISTS %I.%I()', schema_name, audit_function_name);

        -- Build insert/update/delete columns & values
        insert_columns := '';
        insert_values_new := '';
        insert_values_old := '';
        update_assignments := '';
        pk_conditions := '';

        FOR col IN
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = schema_name
              AND table_name = tbl.table_name
            ORDER BY ordinal_position
        LOOP
            insert_columns    := insert_columns    || format('%I, '    , col.column_name);
            insert_values_new := insert_values_new || format('NEW.%I, ', col.column_name);
            insert_values_old := insert_values_old || format('OLD.%I, ', col.column_name);

            IF pk_columns IS NOT NULL AND col.column_name = ANY(pk_columns) THEN
                pk_conditions := pk_conditions || format('%I = NEW.%I AND ', col.column_name, col.column_name);
            ELSE
                update_assignments := update_assignments || format('%I = NEW.%I, ', col.column_name, col.column_name);
            END IF;
        END LOOP;

        -- Clear existing data from encrypted table
        EXECUTE format('TRUNCATE TABLE %I.%I', tbl.table_schema, encrypted_table_name);

        -- Insert encrypted data
        EXECUTE format(
            'INSERT INTO %I.%I SELECT %s FROM %I.%I;',
            tbl.table_schema, encrypted_table_name,
            encrypt_select,
            tbl.table_schema, tbl.table_name);

        RAISE NOTICE 'Copied data to %I.%I', tbl.table_schema, encrypted_table_name;

        -- Add audit columns to insert
        insert_columns    := insert_columns    || 'changed_by, user_ip, action, changed_at';
        insert_values_new := insert_values_new || 'COALESCE(current_setting(''my.user_id'', true)::UUID, ''00000000-0000-0000-0000-000000000000''::UUID),COALESCE(current_setting(''my.ip_address'', true))::text, TG_OP, CURRENT_TIMESTAMP';
        insert_values_old := insert_values_old || 'COALESCE(current_setting(''my.user_id'', true)::UUID, ''00000000-0000-0000-0000-000000000000''::UUID),COALESCE(current_setting(''my.ip_address'', true))::text, TG_OP, CURRENT_TIMESTAMP';
        update_assignments := left(update_assignments, length(update_assignments) - 2);
        pk_conditions := left(pk_conditions, length(pk_conditions) - 5);

        -- Create or replace trigger function
        EXECUTE format($func$
            CREATE FUNCTION %I.%I() RETURNS trigger AS
            $body$
            BEGIN
                IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
                    INSERT INTO %I.%I (%s) VALUES (%s);
                    RETURN NEW;
                ELSIF TG_OP = 'DELETE' THEN
                    INSERT INTO %I.%I (%s) VALUES (%s);
                    RETURN OLD;
                END IF;
                RETURN NULL;
            END
            $body$ LANGUAGE plpgsql;
            $func$,
                schema_name, audit_function_name,
                schema_name, audit_table_name, insert_columns, insert_values_new,
                schema_name, audit_table_name, insert_columns, insert_values_old
        );

        -- Create audit trigger
        EXECUTE format('
            CREATE TRIGGER %I
            AFTER INSERT OR UPDATE OR DELETE ON %I.%I
            FOR EACH ROW EXECUTE FUNCTION %I.%I()
        ', audit_trigger_name, schema_name, encrypted_table_name, schema_name, audit_function_name);

        -- Rename old unencrypted table
        EXECUTE format('ALTER TABLE IF EXISTS %I.%I RENAME TO %I_old;', tbl.table_schema, tbl.table_name, tbl.table_name);

        -- Create view over encrypted table with decryption
        EXECUTE format('
            CREATE OR REPLACE VIEW %I.%I AS SELECT %s FROM %I.%I;
        ', tbl.table_schema, tbl.table_name, decrypt_select, tbl.table_schema, encrypted_table_name);

        -- Create INSTEAD OF trigger function for CRUD via view
        EXECUTE format($func$
        CREATE OR REPLACE FUNCTION %I.%I_view_trigger_fn()
        RETURNS trigger AS
        $body$
        BEGIN
            IF TG_OP = 'INSERT' THEN
                INSERT INTO %I.%I (%s) VALUES (%s);
                RETURN NEW;
            ELSIF TG_OP = 'UPDATE' THEN
                UPDATE %I.%I SET %s WHERE %s;
                RETURN NEW;
            ELSIF TG_OP = 'DELETE' THEN
                DELETE FROM %I.%I WHERE %s;
                RETURN OLD;
            END IF;
            RETURN NULL;
        END
        $body$ LANGUAGE plpgsql;
        $func$,
            schema_name, tbl.table_name,
            schema_name, encrypted_table_name, insert_columns, insert_values_new,
            schema_name, encrypted_table_name, update_assignments, pk_conditions,
            schema_name, encrypted_table_name, pk_conditions);

        -- Attach INSTEAD OF trigger to view
        EXECUTE format('
            DROP TRIGGER IF EXISTS %I_view_trigger ON %I.%I;
            CREATE TRIGGER %I_view_trigger
            INSTEAD OF INSERT OR UPDATE OR DELETE ON %I.%I
            FOR EACH ROW EXECUTE FUNCTION %I.%I_view_trigger_fn();
        ', tbl.table_name, schema_name, tbl.table_name, tbl.table_name, schema_name, tbl.table_name, schema_name, tbl.table_name);

        RAISE NOTICE 'Completed table %.%: encrypted table, audit, view with CRUD', schema_name, tbl.table_name;
    END LOOP;
END
$$;
