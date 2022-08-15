class AddFootnotesVehicleJourneyIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "footnotes_vehicle_journeys", ["vehicle_journey_id"], :name => "footnotes_vehicle_journeys_vehicle_journey_id_idx"
    add_index "footnotes_vehicle_journeys", ["footnote_id"], :name => "footnotes_vehicle_journeys_footnote_id_idx"
  end

  def down
    remove_index "footnotes_vehicle_journeys", :name => "footnotes_vehicle_journeys_vehicle_journey_id_idx" if index_name_exists?(:footnotes_vehicle_journeys, :footnotes_vehicle_journeys_vehicle_journey_id_idx)
    remove_index "footnotes_vehicle_journeys", :name => "footnotes_vehicle_journeys_footnote_id_idx" if index_name_exists?(:footnotes_vehicle_journeys, :footnotes_vehicle_journeys_footnote_id_idx)
  end

end