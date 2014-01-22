class RemoveFormatNoSaveFilePathFromImportTask < ActiveRecord::Migration
  def up
    remove_column :import_tasks, :no_save
    remove_column :import_tasks, :file_path
    remove_column :import_tasks, :format
  end

  def down
    add_column :import_tasks, :no_save, :boolean
    add_column :import_tasks, :file_path, :datatype
    add_column :import_tasks, :format, :datatype
  end
end
