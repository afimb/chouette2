class CreateComplianceCheckTasks < ActiveRecord::Migration[4.2]
  def up
    unless table_exists? :compliance_check_tasks
      create_table :compliance_check_tasks do |t|
        t.belongs_to :referential, :null => :no ,:limit => 8
        t.belongs_to :import_task ,:limit => 8 # optional
        t.string :status      # global status of conformity checking
        t.string :parameter_set_name       # name of parameter set used for testing
        t.text :parameter_set   # all parameters needed to execute the import operation
        t.integer :user_id  ,:limit => 8    # id to the user who has requested this task (may be nil)
        t.string :user_name     # name of the user who has requested this task
        t.text :progress_info # percentage of progress and step code
        t.timestamps
        t.foreign_key :referentials, :dependent => :delete
        t.foreign_key :import_tasks, :dependent => :delete
      end
    end
  end

  def down
    if table_exists? :compliance_check_tasks
      execute "drop table compliance_check_tasks"
      # drop_table :compliance_check_tasks
    end
  end
end
