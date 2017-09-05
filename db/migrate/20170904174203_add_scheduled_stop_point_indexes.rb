class AddScheduledStopPointIndexes < ActiveRecord::Migration
  def change
    add_index "scheduled_stop_points", ["objectid"], :name => "scheduled_stop_points_objectid_key", :unique => true
    add_index "scheduled_stop_points", ["stop_area_objectid_key"], :name => "scheduled_stop_points_stop_area_idx", :unique => false
  end
end
