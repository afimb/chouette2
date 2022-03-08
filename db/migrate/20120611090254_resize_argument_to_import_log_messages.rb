class ResizeArgumentToImportLogMessages < ActiveRecord::Migration[4.2]
  def change
      change_column :import_log_messages, :arguments, :string, :limit => 1000
  end
end
