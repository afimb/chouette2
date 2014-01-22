class DropImportLogMessages < ActiveRecord::Migration
  def up
    if table_exists? :import_log_messages
      execute "DROP TABLE import_log_messages" # fix Foreigner bug < 1.5.0
      # drop_table :import_log_messages
    end
  end

  def down
    unless table_exists? :import_log_messages
      create_table :import_log_messages do |t|
        t.belongs_to :import
        t.string :key
        t.string :arguments,:limit => 1000
        t.integer :position
        t.string :severity
        t.timestamps
      end
      add_index :import_log_messages, :import_id
    end
  end
  

end
