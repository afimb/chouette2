class AddIndexToReferentials < ActiveRecord::Migration
  def up
    remove_index :referentials, :name if index_exists?(:referentials, :name)
    add_index(:referentials, [:name, :organisation_id], unique: true) unless index_exists?(:referentials, [:name, :organisation_id], unique: true)
  end
  
  def data
    execute %q{
      CREATE OR REPLACE FUNCTION update_chouette_schema_with_slug()
        RETURNS VOID AS $$
        DECLARE
          rec_referential RECORD;
          slug_name VARCHAR;
          schema_name VARCHAR;
        BEGIN
          FOR rec_referential IN  SELECT id, slug
                                  FROM referentials
                                  WHERE slug NOT LIKE 'ch\_%' LOOP
            slug_name := rec_referential.slug;
            schema_name := 'ch_' || rec_referential.id;

            IF schema_name <> '' AND slug_name <> '' THEN
              EXECUTE 'ALTER SCHEMA ' || slug_name || ' RENAME TO ' || schema_name;

              EXECUTE 'update referentials' ||
                ' SET slug = '''|| schema_name || ''''
                ' WHERE id =  '|| rec_referential.id;
            END IF;
          END LOOP;
        END;
        $$LANGUAGE plpgsql;
    }
    ActiveRecord::Base.connection.execute("SELECT * from update_chouette_schema_with_slug()")
    ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS update_chouette_schema_with_slug()")
  end
  
  def down
    remove_index :referentials, [:name, :organisation_id] if index_exists?(:referentials, [:name, :organisation_id], unique: true)
    add_index(:referentials, :name, unique: true) unless index_exists?(:referentials, :name)
  end
end
