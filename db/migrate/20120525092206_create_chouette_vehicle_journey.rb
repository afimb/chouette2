class CreateChouetteVehicleJourney < ActiveRecord::Migration[4.2]
  def up
    create_table :vehicle_journeys, :force => true do |t|
      t.integer  "route_id", :limit => 8
      t.integer  "journey_pattern_id", :limit => 8
      t.integer  "time_slot_id", :limit => 8
      t.integer  "company_id", :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "comment"
      t.string   "status_value"
      t.string   "transport_mode"
      t.string   "published_journey_name"
      t.string   "published_journey_identifier"
      t.string   "facility"
      t.string   "vehicle_type_identifier"

      # TODO: delete this column that are here just for chouette-command compliance
      t.integer  "number"
    end
   add_index "vehicle_journeys", ["objectid"], :name => "vehicle_journeys_objectid_key", :unique => true
   add_index "vehicle_journeys", ["route_id"], :name => "index_vehicle_journeys_on_route_id"
  end

  def down
   remove_index "vehicle_journeys", :name => "vehicle_journeys_objectid_key"
   remove_index "vehicle_journeys", :name => "index_vehicle_journeys_on_route_id"
   drop_table :vehicle_journeys
  end
end
