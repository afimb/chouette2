class CreateChouetteTimeTableVehicleJourney < ActiveRecord::Migration[4.2]
  def up
    create_table :time_tables_vehicle_journeys, :id => false, :force => true do |t|
      t.integer  "time_table_id", :limit => 8
      t.integer  "vehicle_journey_id", :limit => 8
    end
   add_index "time_tables_vehicle_journeys", ["time_table_id"], :name => "index_time_tables_vehicle_journeys_on_time_table_id"
   add_index "time_tables_vehicle_journeys", ["vehicle_journey_id"], :name => "index_time_tables_vehicle_journeys_on_vehicle_journey_id"
  end

  def down
   remove_index "time_tables_vehicle_journeys", :name => "index_time_tables_vehicle_journeys_on_time_table_id"
   remove_index "time_tables_vehicle_journeys", :name => "index_time_tables_vehicle_journeys_on_vehicle_journey_id"
   drop_table :time_tables_vehicle_journeys
  end
end
