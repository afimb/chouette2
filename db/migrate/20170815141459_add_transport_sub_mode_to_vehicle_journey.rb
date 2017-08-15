class AddTransportSubModeToVehicleJourney < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :transport_submode_name, :string
  end
end
