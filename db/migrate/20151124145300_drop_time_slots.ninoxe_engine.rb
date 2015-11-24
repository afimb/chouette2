# This migration comes from ninoxe_engine (originally 20151124145016)
class DropTimeSlots < ActiveRecord::Migration
  def change
    drop_table :time_slots
  end
end
