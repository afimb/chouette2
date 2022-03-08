class DropImports < ActiveRecord::Migration[4.2]
  def up
    if table_exists? :imports
      execute "DROP TABLE imports" # fix Foreigner bug < 1.5.0
      # drop_table :imports
    end
  end

  def down
    unless table_exists? :imports
      create_table :imports do |t|
        t.belongs_to :referential
        t.string :status
        t.string :type
        t.string :options
        t.string :file_type
        t.timestamps
      end
      add_index :imports, :referential_id
    end
  end
  
end
