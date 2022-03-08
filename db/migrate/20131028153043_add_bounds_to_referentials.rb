class AddBoundsToReferentials < ActiveRecord::Migration[4.2]
  def change
    change_table :referentials do |t|
      t.text :geographical_bounds
    end
  end
end
