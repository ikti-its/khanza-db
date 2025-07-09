DO
$$
DECLARE
    tbl RECORD;
    col RECORD;

    audit_table_name text;
    audit_function_name text;
    audit_trigger_name text;
    audit_column_defs text;
    
    audit_insert_columns text;
    audit_insert_values_new text;
    audit_insert_values_old text;

    current_column_defs TEXT;
    encrypt_select TEXT;
    pk_columns TEXT[];
    encryption_key TEXT := 'BismillahSidangNilaiA';

    pk_name TEXT;
    pk_def TEXT;
BEGIN
    FOR tbl IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE' --only include tables
            AND table_schema NOT IN ('pg_catalog', 'information_schema') -- exclude system tables
            AND table_name LIKE '%_encrypted'-- include _structure only
    LOOP    
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

        current_column_defs := '';
        audit_column_defs := '';
        encrypt_select := '';
        audit_table_name := REPLACE(tbl.table_name, '_encrypted', '_audit');
        audit_function_name := audit_table_name || '_function';
        audit_trigger_name := audit_table_name || '_trigger';
        audit_insert_columns := '';
        audit_insert_values_new := '';
        audit_insert_values_old := '';

        FOR col IN
            SELECT column_name, data_type, udt_name,
                character_maximum_length, numeric_precision, numeric_scale,
                is_nullable, column_default
            FROM information_schema.columns
            WHERE table_schema = tbl.table_schema AND table_name = tbl.table_name
            ORDER BY ordinal_position
        LOOP
            current_column_defs := format('%I %s, ',
                col.column_name,
                CASE
                    WHEN col.data_type = 'character varying' THEN
                        CASE 
							WHEN col.character_maximum_length IS NULL THEN format('VARCHAR')
							ELSE format('VARCHAR(%s)', col.character_maximum_length)
						END
                    WHEN col.data_type = 'character' THEN format('CHAR(%s)', col.character_maximum_length)
                    WHEN col.data_type = 'numeric' THEN
                        CASE
                            WHEN col.numeric_precision IS NULL THEN 'NUMERIC'
                            WHEN col.numeric_scale IS NULL THEN format('NUMERIC(%s)', col.numeric_precision)
                            ELSE format('NUMERIC(%s,%s)', col.numeric_precision, col.numeric_scale)
                        END
                    WHEN col.data_type = 'USER-DEFINED' THEN col.udt_name
                    ELSE col.data_type
                END
            );
            audit_insert_columns := audit_insert_columns || format('%I, ', col.column_name);
            audit_insert_values_new := audit_insert_values_new || format('NEW.%I, ', col.column_name);
            audit_insert_values_old := audit_insert_values_old || format('OLD.%I, ', col.column_name);

            IF pk_columns IS NOT NULL AND col.column_name = ANY(pk_columns) THEN
                audit_column_defs := audit_column_defs || current_column_defs;
                -- encrypt_select := encrypt_select || format('%I, ', col.column_name);
            ELSE
                audit_column_defs := audit_column_defs || format('%I BYTEA, ', col.column_name);
                -- encrypt_select := encrypt_select || format('pgp_sym_encrypt(%I::text, ''%s''), ', col.column_name, encryption_key);
            END IF;
        END LOOP;
        
        audit_column_defs := left(audit_column_defs, length(audit_column_defs) - 2);
        encrypt_select := left(encrypt_select, length(encrypt_select) - 2);
        audit_insert_columns := left(audit_insert_columns, length(audit_insert_columns) - 2);
        audit_insert_values_new := left(audit_insert_values_new, length(audit_insert_values_new) - 2);
        audit_insert_values_old := left(audit_insert_values_old, length(audit_insert_values_old) - 2);

        -- Create audit table
        EXECUTE format('CREATE TABLE IF NOT EXISTS %I.%I (%s);', 
            tbl.table_schema, audit_table_name, audit_column_defs
        );
        RAISE NOTICE 'Created audit table %.%', 
            tbl.table_schema, audit_table_name;   
        
        -- Create or replace audit function
        EXECUTE format(
            $func$
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
                tbl.table_schema, audit_function_name,
                tbl.table_schema, audit_table_name, audit_insert_columns, audit_insert_values_new,
                tbl.table_schema, audit_table_name, audit_insert_columns, audit_insert_values_old
        );

        -- Create or replace audit trigger
        EXECUTE format('
            CREATE TRIGGER %I
            AFTER INSERT OR UPDATE OR DELETE ON %I.%I
            FOR EACH ROW EXECUTE FUNCTION %I.%I()', 
            audit_trigger_name, tbl.table_schema, tbl.table_name, 
            tbl.table_schema, audit_function_name);
    END LOOP;
END
$$;
