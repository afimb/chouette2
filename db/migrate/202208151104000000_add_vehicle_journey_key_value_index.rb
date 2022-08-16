class AddVehicleJourneyKeyValueIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "vehicle_journeys_key_values", ["vehicle_journey_id"], :name => "vehicle_journeys_key_values_vehicle_journey_id_idx"
  end

  def down
    remove_index "vehicle_journeys_key_values", :name => "vehicle_journeys_key_values_vehicle_journey_id_idx" if index_name_exists?(:vehicle_journeys_key_values, :vehicle_journeys_key_values_vehicle_journey_id_idx)
  end

end