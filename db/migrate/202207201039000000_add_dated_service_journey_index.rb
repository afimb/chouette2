class AddDatedServiceJourneyIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "dated_service_journeys", ["vehicle_journey_id"], :name => "dated_service_journeys_vehicle_journey_id_idx"  unless index_exists?(:dated_service_journeys, [:vehicle_journey_id])
  end

  def down
    remove_index "dated_service_journeys", :name => "dated_service_journeys_vehicle_journey_id_idx" if index_name_exists?(:dated_service_journeys, :dated_service_journeys_vehicle_journey_id_idx)
  end
end
