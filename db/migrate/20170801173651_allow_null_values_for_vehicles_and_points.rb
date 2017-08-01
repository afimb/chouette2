class AllowNullValuesForVehiclesAndPoints < ActiveRecord::Migration
  def change
    change_column :interchanges, :from_point, :string
    change_column :interchanges, :to_point, :string
    change_column :interchanges, :from_vehicle_journey, :string
    change_column :interchanges, :to_vehicle_journey, :string
  end
end
