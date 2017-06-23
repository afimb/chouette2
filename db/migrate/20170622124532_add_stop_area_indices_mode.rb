class AddStopAreaIndicesMode < ActiveRecord::Migration
  def change
    add_index "stop_areas", ["stop_place_type"], :name => "index_stop_areas_on_stop_place_type"
    add_index "stop_areas", ["transport_mode"], :name => "index_stop_areas_on_transport_mode"
    add_index "stop_areas", ["transport_sub_mode"], :name => "index_stop_areas_on_transport_sub_mode"
  end
end
