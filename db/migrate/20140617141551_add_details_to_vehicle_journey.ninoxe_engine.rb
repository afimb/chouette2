# This migration comes from ninoxe_engine (originally 20140617132236)
class AddDetailsToVehicleJourney < ActiveRecord::Migration[4.2]
  def change
    add_column :vehicle_journeys, :mobility_restricted_suitability, :boolean
    add_column :vehicle_journeys, :on_demand_transportation, :boolean
  end
end
