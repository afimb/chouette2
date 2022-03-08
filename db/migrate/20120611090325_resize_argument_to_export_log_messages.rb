class ResizeArgumentToExportLogMessages < ActiveRecord::Migration[4.2]
  def change
      change_column :export_log_messages, :arguments, :string, :limit => 1000
  end
end
