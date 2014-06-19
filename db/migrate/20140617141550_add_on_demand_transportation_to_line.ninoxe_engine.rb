# This migration comes from ninoxe_engine (originally 20140617131630)
class AddOnDemandTransportationToLine < ActiveRecord::Migration
  def change
    add_column :lines, :on_demand_transportation, :boolean
  end
end
