# This migration comes from ninoxe_engine (originally 20141017075627)
class AddGtfsFieldsToLines < ActiveRecord::Migration
  def change
    change_table :lines do |t|
      t.string :url
      t.string :color, :limit => 6
      t.string :text_color, :limit => 6
    end
  end
end
