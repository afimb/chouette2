class CreateExportLogMessages < ActiveRecord::Migration
  def change
    create_table :export_log_messages do |t|
      t.belongs_to :export
      t.string :key
      t.string :arguments
      t.integer :position
      t.string :severity

      t.timestamps
    end
    add_index :export_log_messages, :export_id
  end
end
