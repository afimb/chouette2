class CreateChouetteStopPoint < ActiveRecord::Migration[4.2]
  def up
    create_table "stop_points", :force => true do |t|
      t.integer  "route_id", :limit => 8
      t.integer  "stop_area_id", :limit => 8
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.integer  "position"
    end
    add_index "stop_points", ["objectid"], :name => "stop_points_objectid_key", :unique => true
  end

  def down
  end
end
