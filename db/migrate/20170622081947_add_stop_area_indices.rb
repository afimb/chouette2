class AddStopAreaIndices < ActiveRecord::Migration
  def change
    add_index "stop_areas", ["name"], :name => "index_stop_areas_on_name"
  end
end
