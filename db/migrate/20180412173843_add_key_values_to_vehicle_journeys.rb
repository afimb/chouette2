class AddKeyValuesToVehicleJourneys < ActiveRecord::Migration[4.2]
  def change
    create_table :vehicle_journeys_key_values, :id => false, :force => true do |t|
      t.integer  "vehicle_journey_id"
      t.string   "type_of_key"
      t.string   "key"
      t.string   "value"
    end
    add_foreign_key "vehicle_journeys_key_values", "vehicle_journeys", name: "vehicle_journeys_key_values_vehicle_journey_fkey"
  end
end
