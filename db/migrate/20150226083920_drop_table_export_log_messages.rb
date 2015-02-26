class DropTableExportLogMessages < ActiveRecord::Migration
  def change
    drop_table :export_log_messages
  end
end
