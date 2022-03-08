class AddServiceAlterationToVehicleJourneys < ActiveRecord::Migration[4.2]
  def change
    add_column :vehicle_journeys, :service_alteration, :string, null: true
  end
end
