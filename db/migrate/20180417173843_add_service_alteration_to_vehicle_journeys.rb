class AddServiceAlterationToVehicleJourneys < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :service_alteration, :string, null: true
  end
end
