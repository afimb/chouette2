class AddPrivateCodeToVehicleJourneys < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :private_code, :string, null: true
    def data
      ActiveRecord::Base.connection.execute("update vehicle_journeys set private_code=number")
    end
  end
end
