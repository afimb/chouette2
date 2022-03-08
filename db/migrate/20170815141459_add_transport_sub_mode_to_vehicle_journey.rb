class AddTransportSubModeToVehicleJourney < ActiveRecord::Migration[4.2]
  def change
    add_column :vehicle_journeys, :transport_submode_name, :string
  end
end
