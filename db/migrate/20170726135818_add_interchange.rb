class AddInterchange < ActiveRecord::Migration[4.2]
  def up
    create_table "interchanges", :force => true do |t|
      t.string   "objectid",       :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.integer  "priority"
      t.boolean  "planned"
      t.boolean  "guaranteed"
      t.boolean  "advertised"
      t.time     "maximum_wait_time"
      t.string   "from_point",      :null => false
      t.string   "to_point",      :null => false
      t.string   "from_vehicle_journey",      :null => false
      t.string   "to_vehicle_journey",      :null => false

    end
    add_index "interchanges", ["objectid"], :name => "interchanges_objectid_key", :unique => true
    add_index "interchanges", ["from_point"], :name => "interchanges_from_point_key"
    add_index "interchanges", ["to_point"], :name => "interchanges_to_poinnt_key"
    add_index "interchanges", ["from_vehicle_journey"], :name => "interchanges_from_vehicle_journey_key"
    add_index "interchanges", ["objectid"], :name => "interchanges_to_vehicle_journey_key"


  end

  def down
    drop_table interchanges
  end
end
