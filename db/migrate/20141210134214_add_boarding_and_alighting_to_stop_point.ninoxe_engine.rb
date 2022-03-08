# This migration comes from ninoxe_engine (originally 20141210123519)
class AddBoardingAndAlightingToStopPoint < ActiveRecord::Migration[4.2]
  def change
    add_column :stop_points, :for_boarding, :string
    add_column :stop_points, :for_alighting, :string

    add_column :vehicle_journey_at_stops, :for_boarding, :string
    add_column :vehicle_journey_at_stops, :for_alighting, :string
  end
end
