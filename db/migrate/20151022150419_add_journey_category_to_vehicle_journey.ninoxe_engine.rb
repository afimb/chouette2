# This migration comes from ninoxe_engine (originally 20151022150156)
class AddJourneyCategoryToVehicleJourney < ActiveRecord::Migration[4.2]
  def change
    add_column :vehicle_journeys, :journey_category, :integer, null: false, default: 0
  end
end
