class AddVehicleJourneyIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "vehicle_journeys", ["journey_pattern_id"], :name => "vehicle_journeys_journey_pattern_id_idx"
  end

  def down
    remove_index "vehicle_journeys", :name => "vehicle_journeys_journey_pattern_id_idx" if index_name_exists?(:vehicle_journeys, :vehicle_journeys_journey_pattern_id_idx)
  end

end
