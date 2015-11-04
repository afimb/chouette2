# This migration comes from ninoxe_engine (originally 20151022150156)
class AddJourneyCategoryToVehicleJourney < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :journey_category, :integer, null: false, default: 0
  end
end
