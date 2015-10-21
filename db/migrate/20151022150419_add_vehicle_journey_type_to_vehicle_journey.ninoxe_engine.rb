# This migration comes from ninoxe_engine (originally 20151022150156)
class AddVehicleJourneyTypeToVehicleJourney < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :vehicle_journey_type, :integer, null: false, default: 0
  end
end
