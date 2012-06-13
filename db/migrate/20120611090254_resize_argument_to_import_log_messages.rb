class ResizeArgumentToImportLogMessages < ActiveRecord::Migration
  def change
      change_column :import_log_messages, :arguments, :string, :limit => 1000
  end
end
