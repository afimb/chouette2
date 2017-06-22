class AddNetexStopPlaceTypeTransportModeAndTransportSubModeToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :stop_place_type, :string
    add_column :stop_areas, :transport_mode, :string
    add_column :stop_areas, :transport_sub_mode, :string
  end
end


