class AddNetexStopPlaceTypeTransportModeAndTransportSubModeToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :stop_place_type_name, :string
    add_column :stop_areas, :transport_mode_name, :string
    add_column :stop_areas, :transport_sub_mode_name, :string
  end
end


