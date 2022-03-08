# This migration comes from ninoxe_engine (originally 20151124145016)
class DropTimeSlots < ActiveRecord::Migration[4.2]
  def change
    drop_table :time_slots
  end
end
