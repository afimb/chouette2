CREATE OR REPLACE FUNCTION clone_schema(source_schema text, dest_schema text) RETURNS void AS
$$

DECLARE
  object text;
  buffer text;
  default_ text;
  column_ text;
BEGIN
  EXECUTE 'DROP SCHEMA IF EXISTS ' || dest_schema || ' CASCADE';
  EXECUTE 'CREATE SCHEMA ' || dest_schema ;

  -- TODO: Find a way to make this sequence's owner is the correct table.
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

  buffer := dest_schema || '.schema_migrations';

  EXECUTE 'INSERT INTO ' || buffer || ' SELECT * from public.schema_migrations';

END;

$$ LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE FUNCTION create_provider_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, admin_user_email text , user_name text, user_email text, organisation_name text, dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text) RETURNS void AS
$$

DECLARE
BEGIN
  PERFORM clone_schema('public',dest_schema);
  REASSIGN OWNED BY postgres TO chouette;
  insert into public.organisations(name,created_at,updated_at,data_format) values (organisation_name,current_timestamp,current_timestamp,dataspace_format);
  insert into public.users(email, encrypted_password,organisation_id,name,confirmed_at) values (admin_user_email,'$2a$10$z8UGGP/r4GDFab6zcd2z8.3BmacPNxaHMIE5ZDgZlBKS88YUDZYVC',  currval(pg_get_serial_sequence('organisations','id')),admin_user_name,current_timestamp);
  insert into public.users(email, encrypted_password,organisation_id,name,confirmed_at) values (user_email,'$2a$10$epwP6Idkzt4W1qUrbomliOy54qwY9.zmrxF.Mgh8MxJSWwq8bGIi2',  currval(pg_get_serial_sequence('organisations','id')),user_name,current_timestamp);
  insert into public.referentials(name,slug,created_at,updated_at,prefix,projection_type, time_zone, bounds,organisation_id , geographical_bounds , user_id ,user_name ,data_format ) values(dataspace_name,dest_schema, current_timestamp,current_timestamp,dataspace_prefix,dataspace_projection,dataspace_timezone,dataspace_bounds,currval(pg_get_serial_sequence('organisations','id')),null,currval(pg_get_serial_sequence('users','id')),admin_user_name,dataspace_format);

 END;

$$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION create_rutebanken_schema(dest_schema text, dataspace_name text, dataspace_format text, admin_user_name text, organisation_id bigint, user_id bigint,dataspace_prefix text, dataspace_projection text , dataspace_timezone text, dataspace_bounds text) RETURNS void AS
$$

DECLARE
BEGIN
  PERFORM clone_schema('public',dest_schema);
  REASSIGN OWNED BY postgres TO chouette;
 insert into public.referentials(name,slug,created_at,updated_at,prefix,projection_type, time_zone, bounds,organisation_id , geographical_bounds , user_id ,user_name ,data_format )
   values(dataspace_name,dest_schema, current_timestamp,current_timestamp,dataspace_prefix,dataspace_projection,dataspace_timezone,dataspace_bounds,organisation_id,null,user_id,admin_user_name,dataspace_format);

 END;

$$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION set_variable( IN p_var TEXT, IN p_val bigint ) RETURNS void as $$
DECLARE
    v_var TEXT;
BEGIN
    execute 'CREATE temp TABLE IF NOT exists sys_variables ( variable TEXT PRIMARY KEY, value bigint );';
    LOOP
        execute 'UPDATE sys_variables SET value = $1 WHERE variable = $2 returning variable' INTO v_var USING p_val, p_var;
        IF v_var IS NOT NULL THEN
            RETURN;
        END IF;
        BEGIN
            execute 'INSERT INTO sys_variables ( variable, value ) VALUES ( $1, $2 )' USING p_var, p_val;
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- ignore, re-process the loop
        END;
    END LOOP;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_variable( IN p_var TEXT ) RETURNS bigint as $$
DECLARE
    v_val TEXT;
BEGIN
    execute 'CREATE temp TABLE IF NOT exists sys_variables ( variable TEXT PRIMARY KEY, value bigint );';
    execute 'SELECT value FROM sys_variables WHERE variable = $1' INTO v_val USING p_var;
    RETURN v_val;
END;
$$ language plpgsql;

delete from public.organisations;
delete from public.users;
delete from public.referentials;


insert into public.organisations(name,created_at,updated_at,data_format) values ('Rutebanken',current_timestamp,current_timestamp,'gtfs');
insert into public.users(email, encrypted_password,organisation_id,name,confirmed_at) values ('admin@rutebanken.org','$2a$10$z8UGGP/r4GDFab6zcd2z8.3BmacPNxaHMIE5ZDgZlBKS88YUDZYVC',  currval(pg_get_serial_sequence('organisations','id')),'Rutebanken Admin',current_timestamp);

select set_variable('user_id',currval(pg_get_serial_sequence('users','id')));
select set_variable('organisation_id',currval(pg_get_serial_sequence('organisations','id')));

SELECT create_provider_schema('ost','Østfold Kollektivtrafikk','gtfs','Rutebanken Admin','admin+ost@rutebanken.org','Østfold-bruker','ost@rutebanken.org','Østfold Kollektivtrafikk AS','OST','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_ost','RB/Østfold Kollektivtrafikk','gtfs','Rutebanken Admin', get_variable('organisation_id'), get_variable('user_id'),'OST','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('rut','Ruter','gtfs','Rutebanken Admin','admin+rut@rutebanken.org','Ruter-bruker','rut@rutebanken.org','Ruter AS','RUT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_rut','RB/Ruter','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'RUT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('hed','Hedmark-Trafikk','gtfs','Rutebanken Admin','admin+hed@rutebanken.org','Hedmark-bruker','hed@rutebanken.org','Hedmark-Trafikk AS','HED','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_hed','RB/Hedmark-Trafikk','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'HED','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('opp','Opplandstrafikk','gtfs','Rutebanken Admin','admin+opp@rutebanken.org','Opplands-bruker','opp@rutebanken.org','Opplandstrafikk AS','OPP','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_opp','RB/Opplandstrafikk','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'OPP','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('bra','Brakar','gtfs','Rutebanken Admin','admin+bra@rutebanken.org','Brakar-bruker','bra@rutebanken.org','Brakar AS','BRA','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_bra','RB/Brakar','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'BRA','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('vkt','Vestfold Kollektivtrafikk','gtfs','Rutebanken Admin','admin+vkt@rutebanken.org','Vestfold-bruker','vkt@rutebanken.org','Vestfold Kollektivtrafikk AS','VKT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_vkt','RB/Vestfold','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'VKT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('akt','Agder Kollektivtrafik','gtfs','Rutebanken Admin','admin+akt@rutebanken.org','Akt-bruker','akt@rutebanken.org','Agder Kollektivtrafik AS','AKT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_akt','RB/AkT','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'AKT','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('kol','Kolumbus','gtfs','Rutebanken Admin','admin+kol@rutebanken.org','Kolumbus-bruker','kol@rutebanken.org','Kolumbus AS','KOL','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_kol','RB/Kolumbus','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'KOL','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('hrd','Skyss','gtfs','Rutebanken Admin','admin+hrd@rutebanken.org','Skyss-bruker','hrd@rutebanken.org','Skyss AS','HRD','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_hrd','RB/Skyss','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'HRD','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('sof','Kringom','gtfs','Rutebanken Admin','admin+sof@rutebanken.org','Kringom-bruker','sof@rutebanken.org','Kringom AS','SOF','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_sof','RB/Kringom','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'SOF','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('mor','Fram','gtfs','Rutebanken Admin','admin+mor@rutebanken.org','Fram-bruker','mor@rutebanken.org','Fram AS','MOR','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_mor','RB/Fram','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'MOR','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('atb','AtB','gtfs','Rutebanken Admin','admin+atb@rutebanken.org','AtB-bruker','atb@rutebanken.org','AtB AS','ATB','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_atb','RB/AtB','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'ATB','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('ntr','Nord-Trøndelag','gtfs','Rutebanken Admin','admin+ntr@rutebanken.org','NTR-bruker','ntr@rutebanken.org','Nord-Trøndelag FK AS','NTR','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_ntr','RB/Nord-Trøndelag','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'NTR','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('nor','Nordland','gtfs','Rutebanken Admin','admin+nor@rutebanken.org','Nordland-bruker','nor@rutebanken.org','Nordland/Cominor AS','NOR','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_nor','RB/Nordland','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'NOR','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('tro','Troms','gtfs','Rutebanken Admin','admin+tro@rutebanken.org','Troms-bruker','tro@rutebanken.org','Troms FK AS','TRO','32633','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_tro','RB/Troms','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'TRO','32633','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('fin','Snelandia','gtfs','Rutebanken Admin','admin+fin@rutebanken.org','Snelandia-bruker','fin@rutebanken.org','Snelandia AS','FIN','32633','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_fin','RB/Snelandia','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'FIN','32633','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('tog','NSB','gtfs','Rutebanken Admin','admin+tog@rutebanken.org','NSB/Tog-bruker','tog@rutebanken.org','NSB AS','TOG','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_tog','RB/NSB','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'TOG','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('tel','Telemark Kollektivtrafik','gtfs','Rutebanken Admin','admin+tel@rutebanken.org','Telemark-bruker','tel@rutebanken.org','Telemark FK AS','TEL','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_tel','RB/Telemark Kollektivtrafik','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'TEL','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('nri','NRI','gtfs','Rutebanken Admin','admin+nri@rutebanken.org','NRI-bruker','nri@rutebanken.org','Norsk Reiseinformasjon AS','NRI','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_nri','RB/NRI','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'NRI','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('norway','NOR-WAY Bussekspress','gtfs','Rutebanken Admin','admin+norway@rutebanken.org','NOR-WAY-bruker','norway@rutebanken.org','NOR-WAY Bussekspress AS','NORWAY','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_norway','RB/NOR-WAY','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'NORWAY','32632','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');

SELECT create_provider_schema('avinor','Avinor','gtfs','Rutebanken Admin','admin+avinor@rutebanken.org','Avinor-bruker','avinor@rutebanken.org','Avinor Flysikring AS','AVINOR','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
SELECT create_rutebanken_schema('rb_avinor','RB/Avinor','gtfs','Rutebanken Admin',get_variable('organisation_id'), get_variable('user_id'),'AVI','4326','Paris','SRID=4326;POLYGON((3.0 57.0,3.0 62.0,10.0 62.0,10.0 57.0,3.0 57.0))');
