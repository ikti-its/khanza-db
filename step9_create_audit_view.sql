DO
$$
DECLARE
    tbl RECORD;
    col RECORD;
    decrypt_select TEXT;
    pk_columns TEXT[];
    encryption_key TEXT := 'BismillahSidangNilaiA';
    audit_view_name TEXT;
    audit_table_name TEXT;
    audit_insert_columns text;
    audit_insert_values text;
    audit_update_assignments text;
BEGIN
    FOR tbl IN
        SELECT table_schema, table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE' --only include tables
            AND table_schema NOT IN ('pg_catalog', 'information_schema') -- exclude system tables
            AND table_name LIKE '%_encrypted'-- include _audit only
    LOOP    
        RAISE NOTICE '%', tbl.table_name;
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
        RAISE NOTICE '%', pk_columns;

        decrypt_select := '';
        audit_insert_columns := '';
        audit_insert_values := '';

        FOR col IN
            SELECT column_name, data_type, udt_name
            FROM information_schema.columns
            WHERE table_schema = tbl.table_schema AND table_name = tbl.table_name
            ORDER BY ordinal_position
        LOOP
            IF pk_columns IS NOT NULL AND col.column_name = ANY(pk_columns) THEN
                -- Handle SELECTs
                decrypt_select := decrypt_select || 
                    format('%I, ', col.column_name
                );
                -- Handle INSERTs
                audit_insert_columns := audit_insert_columns || 
                    format('%I, ', col.column_name
                );
                audit_insert_values := audit_insert_values || 
                    format('NEW.%I, ', col.column_name
                );
            ELSE
                -- Handle SELECTs
                decrypt_select := decrypt_select || format('pgp_sym_decrypt(%I, ''%s'')::%s AS %I, ',
                    col.column_name, encryption_key,
                    CASE WHEN col.data_type = 'USER-DEFINED' THEN col.udt_name ELSE col.data_type END,
                    col.column_name
                );
                -- Handle INSERTs
                audit_insert_columns := audit_insert_columns || 
                    format('%I, ', col.column_name
                );
                audit_insert_values := audit_insert_values || 
                    format('pgp_sym_encrypt(NEW.%I::text, ''%s''), ', col.column_name, encryption_key
                );
            END IF;
        END LOOP;

        RAISE NOTICE '%', audit_insert_columns;
        RAISE NOTICE '%', audit_insert_values;

        decrypt_select := left(decrypt_select, length(decrypt_select) - 2);
        audit_insert_columns := left(audit_insert_columns, length(audit_insert_columns) - 2);
        audit_insert_values := left(audit_insert_values, length(audit_insert_values) - 2);
       
        audit_view_name = REPLACE(tbl.table_name, '_encrypted', '_audit_view');
        audit_table_name = REPLACE(tbl.table_name, '_encrypted', '_audit');

        -- Create view based on _audit tables
        EXECUTE format('
            CREATE OR REPLACE VIEW %I.%I AS SELECT %s FROM %I.%I;', 
            tbl.table_schema, audit_view_name, decrypt_select, tbl.table_schema, audit_table_name
        );
    END LOOP;
END
$$;
