class CreateFileValidationLogMessages < ActiveRecord::Migration
  def up
    create_table :file_validation_log_messages do |t|
      t.belongs_to :file_validation
      t.string :key
      t.string :arguments, :limit => 1000
      t.integer :position
      t.string :severity

      t.timestamps
    end
    add_index :file_validation_log_messages, :file_validation_id
  end

  def down
    drop_table :file_validation_log_messages
  end
end
