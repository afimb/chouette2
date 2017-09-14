class LinkFootnotesToStopPointAndVehicleJourneyAtStop < ActiveRecord::Migration
  def change
    create_table :footnotes_stop_points, :id => false, :force => true do |t|
      t.integer  "stop_point_id"
      t.integer  "footnote_id"
    end
    add_index "footnotes_stop_points", ["stop_point_id"], :name => "stop_point_id_idx"
    add_index "footnotes_stop_points", ["footnote_id"], :name => "footnotes_stop_point_id_idx"

    create_table :footnotes_vehicle_journey_at_stops, :id => false, :force => true do |t|
      t.integer  "vehicle_journey_at_stop_id"
      t.integer  "footnote_id"
    end
    add_index "footnotes_vehicle_journey_at_stops", ["vehicle_journey_at_stop_id"], :name => "vehicle_journey_at_stop_id_idx"
    add_index "footnotes_vehicle_journey_at_stops", ["footnote_id"], :name => "footnotes_vehicle_journey_at_stop_id_idx"

  end
end
