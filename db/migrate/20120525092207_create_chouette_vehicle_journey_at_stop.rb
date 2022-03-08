class CreateChouetteVehicleJourneyAtStop < ActiveRecord::Migration[4.2]
  def up
    create_table :vehicle_journey_at_stops, :force => true do |t|
      t.integer  "vehicle_journey_id", :limit => 8
      t.integer  "stop_point_id", :limit => 8

      t.string  "connecting_service_id"
      t.string  "boarding_alighting_possibility"
      
      t.time "arrival_time"
      t.time "departure_time"
      t.time "waiting_time"
      t.time "elapse_duration"
      t.time "headway_frequency"
    end
   add_index "vehicle_journey_at_stops", ["vehicle_journey_id"], :name => "index_vehicle_journey_at_stops_on_vehicle_journey_id"
   add_index "vehicle_journey_at_stops", ["stop_point_id"], :name => "index_vehicle_journey_at_stops_on_stop_pointid"
  end

  def down
   remove_index "vehicle_journey_at_stops", :name => "index_vehicle_journey_at_stops_on_vehicle_journey_id"
   remove_index "vehicle_journey_at_stops", :name => "index_vehicle_journey_at_stops_on_stop_point_id"
   drop_table :vehicle_journey_at_stops
  end
end
