class DropTableExportLogMessages < ActiveRecord::Migration[4.2]
  def change
    drop_table :export_log_messages
  end
end
