class CreateFileValidations < ActiveRecord::Migration
  def up
    create_table :file_validations do |t|
      t.string :status
      t.string :options, :limit => 2000
      t.string :file_name
      t.string :file_type
      t.timestamps
    end
  end

  def down
    drop_table :file_validations
  end
end
