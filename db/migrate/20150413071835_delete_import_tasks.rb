class DeleteImportTasks < ActiveRecord::Migration[4.2]
  def change
    drop_table :compliance_check_results
    drop_table :compliance_check_tasks
    drop_table :import_tasks
  end
end
