class CreateImportLogMessages < ActiveRecord::Migration
  def change
    create_table :import_log_messages do |t|
      t.belongs_to :import
      t.string :key
      t.string :arguments
      t.integer :position
      t.string :severity

      t.timestamps
    end
    add_index :import_log_messages, :import_id
  end
end
