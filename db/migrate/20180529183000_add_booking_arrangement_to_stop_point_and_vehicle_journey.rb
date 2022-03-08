class AddBookingArrangementToStopPointAndVehicleJourney < ActiveRecord::Migration[4.2]
  def change

      create_table :flexible_service_properties, :force => true do |t|
        t.string "objectid", null: false
        t.integer "object_version"
        t.datetime "creation_time"
        t.string "creator_id", limit: 255
        t.string "flexible_service_type", limit: 255
        t.boolean "cancellation_possible"
        t.boolean "change_of_time_possible"
        t.integer "booking_arrangement_id"
      end
      add_index "flexible_service_properties", ["objectid"], :name => "flexible_service_propertiess_objectid_key", :unique => true

    add_column :vehicle_journeys, :flexible_service_properties_id, :integer, null: true
    add_column :stop_points, :booking_arrangement_id, :integer, null: true

    add_foreign_key "vehicle_journeys", "flexible_service_properties", column: "flexible_service_properties_id", name: "vehicle_journeys_flexible_props_fkey"
    add_foreign_key "flexible_service_properties", "booking_arrangements", column: "booking_arrangement_id", name: "flexible_props_booking_arrangement_fkey"
    add_foreign_key "stop_points", "booking_arrangements", column: "booking_arrangement_id", name: "stop_points_booking_arrangement_fkey"


  end
end
