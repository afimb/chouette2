class AddTransportModeNameToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :transport_mode_name, :string
  end
end
