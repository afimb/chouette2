class CreateImports < ActiveRecord::Migration[4.2]
  def change
    create_table :imports do |t|
      t.belongs_to :referential
      t.string :status

      t.timestamps
    end
    add_index :imports, :referential_id
  end
end
