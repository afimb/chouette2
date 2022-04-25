class UpdateCloneSchemaForHibernatePooledOptimizer < ActiveRecord::Migration[4.2]

  def data
    execute %q{


CREATE OR REPLACE FUNCTION clone_schema(source_schema text, dest_schema text) RETURNS void AS
$$

DECLARE
  object text;
  sequence_config record;
  buffer text;
  default_ text;
  column_ text;
  constraint_name_ text;
  constraint_def_ text;
BEGIN
  EXECUTE 'DROP SCHEMA IF EXISTS ' || dest_schema || ' CASCADE';
  EXECUTE 'CREATE SCHEMA ' || dest_schema ;
  SET search_path TO dest_schema;

  FOR sequence_config IN
    SELECT sequence_name::text, increment::text FROM information_schema.SEQUENCES WHERE sequence_schema = source_schema
  LOOP
    EXECUTE 'CREATE SEQUENCE ' || dest_schema || '.' || sequence_config.sequence_name || ' INCREMENT BY ' || sequence_config.increment;
  END LOOP;

  FOR object IN
    SELECT TABLE_NAME::text FROM information_schema.TABLES WHERE table_schema = source_schema
  LOOP
    buffer := dest_schema || '.' || object;
    EXECUTE 'CREATE TABLE ' || buffer || ' (LIKE ' || source_schema || '.' || object || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';

    FOR column_, default_ IN
      SELECT column_name::text, REPLACE(column_default::text, source_schema, dest_schema) FROM information_schema.COLUMNS WHERE table_schema = dest_schema AND TABLE_NAME = object AND column_default LIKE 'nextval(%' || source_schema || '%::regclass)'
    LOOP
      EXECUTE 'ALTER TABLE ' || buffer || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;
    END LOOP;
  END LOOP;

  -- reiterate tables and create foreign keys
   FOR object IN
     SELECT table_name::text FROM information_schema.TABLES WHERE table_schema = source_schema
   LOOP
     buffer := dest_schema || '.' || object;

     -- create foreign keys
     FOR constraint_name_, constraint_def_ IN
       SELECT conname::text, REPLACE(pg_get_constraintdef(pg_constraint.oid), source_schema||'.', dest_schema||'.')  FROM pg_constraint INNER JOIN pg_class ON conrelid=pg_class.oid INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace WHERE contype='f' and relname=object and nspname=source_schema
     LOOP
       --raise notice 'constraint "%" "%"', constraint_name_, constraint_def_;
       EXECUTE 'ALTER TABLE '|| buffer ||' ADD CONSTRAINT '|| constraint_name_ ||' '|| constraint_def_;
     END LOOP;
   END LOOP;

  buffer := dest_schema || '.schema_migrations';

  EXECUTE 'INSERT INTO ' || buffer || ' SELECT * from public.schema_migrations';
   SET search_path TO public;

END;

$$ LANGUAGE plpgsql VOLATILE;




    }
  end

end
