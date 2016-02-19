# This migration comes from ninoxe_engine (originally 20151124144002)
class RemoveWaitingTimeElapseDurationHeadwayFrequencyToVehicleJourneyAtStops < ActiveRecord::Migration
  def up
    remove_column :vehicle_journey_at_stops, :waiting_time
    remove_column :vehicle_journey_at_stops, :elapse_duration
    remove_column :vehicle_journey_at_stops, :headway_frequency
  end

  def down
    add_column :vehicle_journey_at_stops, :waiting_time, :time
    add_column :vehicle_journey_at_stops, :elapse_duration, :time
    add_column :vehicle_journey_at_stops, :headway_frequency, :time
  end
end
