class ResizeArgumentToExportLogMessages < ActiveRecord::Migration
  def change
      change_column :export_log_messages, :arguments, :string, :limit => 1000
  end
end
