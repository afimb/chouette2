# This migration comes from ninoxe_engine (originally 20151124145000)
class RemoveTimeSlotIdFromVehicleJourney < ActiveRecord::Migration
  def up
    if column_exists? :vehicle_journeys, :time_slot_id
       remove_column :vehicle_journeys, :time_slot_id
    end
  end
  def down
    add_column :vehicle_journeys, :time_slot_id, "integer", {:limit => 8}
  end
end
