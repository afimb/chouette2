class CreateReferentials < ActiveRecord::Migration
  def change
    create_table :referentials do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
