class CreateReferentials < ActiveRecord::Migration[4.2]
  def change
    create_table :referentials do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
