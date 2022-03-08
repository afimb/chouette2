# This migration comes from ninoxe_engine (originally 20141017075515)
class AddGtfsFieldsToStopAreas < ActiveRecord::Migration[4.2]
  def change
    change_table :stop_areas do |t|
      t.string :url
      t.string :time_zone
    end
  end
end
