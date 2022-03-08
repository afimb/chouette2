class AddOnDeleteCascadeToVehicleJourneysKeyValues < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key "vehicle_journeys_key_values", name: "vehicle_journeys_key_values_vehicle_journey_fkey"
    add_foreign_key "vehicle_journeys_key_values", "vehicle_journeys", name: "vehicle_journeys_key_values_vehicle_journey_fkey", on_delete: :cascade
  end
end
