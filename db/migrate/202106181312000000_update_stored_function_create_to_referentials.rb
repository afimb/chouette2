class UpdateStoredFunctionCreateToReferentials < ActiveRecord::Migration

  def data
    execute %q{

DROP FUNCTION IF EXISTS create_provider_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, admin_user_email text , user_name text, user_email text, organisation_name text, dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text, xmlns text, xmlns_url text);
DROP FUNCTION IF EXISTS create_rutebanken_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, organisation_id bigint, user_id bigint,dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text, xmlns text, xmlns_url text);


CREATE OR REPLACE FUNCTION clone_schema(source_schema text, dest_schema text) RETURNS void AS
$$

DECLARE
  object text;
  buffer text;
  default_ text;
  column_ text;
  constraint_name_ text;
  constraint_def_ text;
BEGIN
  EXECUTE 'DROP SCHEMA IF EXISTS ' || dest_schema || ' CASCADE';
  EXECUTE 'CREATE SCHEMA ' || dest_schema ;
  SET search_path TO dest_schema;

  FOR object IN
    SELECT sequence_name::text FROM information_schema.SEQUENCES WHERE sequence_schema = source_schema
  LOOP
    EXECUTE 'CREATE SEQUENCE ' || dest_schema || '.' || object;
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


CREATE OR REPLACE FUNCTION create_provider_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, admin_user_email text , admin_user_encrypted_password text, user_name text, user_email text, user_initial_encrypted_password text, organisation_name text, dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text, xmlns text, xmlns_url text) RETURNS integer AS
$$

DECLARE
BEGIN
  raise notice 'create schema "%"', dest_schema;
  PERFORM public.clone_schema('public',dest_schema);
  raise notice 'Reassigning ownership from postgres to chouette. db: % user: % schema: %', current_database(), current_user, current_schema();
  set search_path to dest_schema;
  --REASSIGN OWNED BY postgres TO chouette;
  execute 'insert into ' || dest_schema  || '.codespaces ( xmlns, xmlns_url, created_at ) values ( $1, $2, $3 )' USING 'NSR', 'http://www.rutebanken.org/ns/nsr', current_timestamp;
  execute 'insert into ' || dest_schema  || '.codespaces ( xmlns, xmlns_url, created_at ) values ( $1, $2, $3 )' USING xmlns, xmlns_url, current_timestamp;
  set search_path to public;
  insert into public.organisations(name,created_at,updated_at,data_format) values (organisation_name,current_timestamp,current_timestamp,dataspace_format);
  insert into public.users(email, encrypted_password,organisation_id,name,confirmed_at,role) values (admin_user_email,admin_user_encrypted_password,  currval(pg_get_serial_sequence('organisations','id')),admin_user_name,current_timestamp,2);
  insert into public.users(email, encrypted_password,organisation_id,name,confirmed_at) values (user_email,user_initial_encrypted_password,  currval(pg_get_serial_sequence('organisations','id')),user_name,current_timestamp);
  insert into public.referentials(name,slug,created_at,updated_at,prefix,projection_type, time_zone, bounds,organisation_id , geographical_bounds , user_id ,user_name ,data_format ) values(dataspace_name,dest_schema, current_timestamp,current_timestamp,dataspace_prefix,dataspace_projection,dataspace_timezone,dataspace_bounds,currval(pg_get_serial_sequence('organisations','id')),null,currval(pg_get_serial_sequence('users','id')),admin_user_name,dataspace_format);
  RETURN 1;
END;

$$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION create_rutebanken_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, master_organisation_name text, master_user_email text, dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text, xmlns text, xmlns_url text) RETURNS integer AS
$$

DECLARE
  master_user_id   integer;
  master_organisation_id   integer;
BEGIN
  PERFORM public.clone_schema('public',dest_schema);

  select id into master_user_id from public.users where email = master_user_email;
  select id into master_organisation_id from public.organisations where name = master_organisation_name;


  -- REASSIGN OWNED BY postgres TO chouette;
 insert into public.referentials(name,slug,created_at,updated_at,prefix,projection_type, time_zone, bounds,organisation_id , geographical_bounds , user_id ,user_name ,data_format )
   values(dataspace_name,dest_schema, current_timestamp,current_timestamp,dataspace_prefix,dataspace_projection,dataspace_timezone,dataspace_bounds,master_organisation_id,null,master_user_id,admin_user_name,dataspace_format);

 execute 'insert into ' || dest_schema  || '.codespaces ( xmlns, xmlns_url, created_at ) values ( $1, $2, $3 )' USING 'NSR', 'http://www.rutebanken.org/ns/nsr', current_timestamp;
 execute 'insert into ' || dest_schema  || '.codespaces ( xmlns, xmlns_url, created_at ) values ( $1, $2, $3 )' USING xmlns, xmlns_url, current_timestamp;
 RETURN 1;
 END;

$$ LANGUAGE plpgsql VOLATILE;

    }
  end
  
end
