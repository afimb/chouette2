class CreateImportTasks < ActiveRecord::Migration[4.2]
  def up
    unless table_exists? :import_tasks
      create_table :import_tasks do |t|
        t.belongs_to :referential ,:limit => 8
        t.string :status        # pending processing completed failed
        t.string :format        # NEPTUNE, CSV, NETEX, GTFS
        t.boolean :no_save      # processing no save on database (exclude level 3 conformity testing)
        t.text :parameter_set   # all parameters needed to execute the import operation
        t.integer :user_id ,:limit => 8     # id to the user who has requested this task (may be nil)
        t.string :user_name     # name of the user who has requested this task
        t.string  :file_path    # saved file
        t.text :result          # import report : objects statistics
        t.text :progress_info   # percentage of progress and step code
        t.timestamps
        t.foreign_key :referentials, :dependent => :delete
      end
    end
  end

  def down
    if table_exists? :import_tasks
      execute "drop table import_tasks"
      # drop_table :import_tasks
    end
  end
end
