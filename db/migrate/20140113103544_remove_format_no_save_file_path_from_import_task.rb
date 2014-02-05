class RemoveFormatNoSaveFilePathFromImportTask < ActiveRecord::Migration
  def up
    remove_column :import_tasks, :no_save
    remove_column :import_tasks, :file_path
    remove_column :import_tasks, :format
  end

  def down
    add_column :import_tasks, :no_save, :boolean
    add_column :import_tasks, :file_path, :string
    add_column :import_tasks, :format, :string
  end
end
