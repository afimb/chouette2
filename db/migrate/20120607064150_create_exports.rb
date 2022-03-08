class CreateExports < ActiveRecord::Migration[4.2]
  def change
    create_table :exports do |t|
      t.belongs_to :referential
      t.string :status
      t.string :type
      t.string :options

      t.timestamps
    end
    add_index :exports, :referential_id
  end
end
