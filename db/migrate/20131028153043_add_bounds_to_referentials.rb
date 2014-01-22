class AddBoundsToReferentials < ActiveRecord::Migration
  def change
    change_table :referentials do |t|
      t.text :geographical_bounds
    end
  end
end
