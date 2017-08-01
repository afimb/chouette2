class AllowNullValuesForVehiclesAndPoints < ActiveRecord::Migration
  def change
    change_column :interchanges, :from_point, :string, :null => true
    change_column :interchanges, :to_point, :string, :null => true
    change_column :interchanges, :from_vehicle_journey, :string, :null => true
    change_column :interchanges, :to_vehicle_journey, :string, :null => true
  end
end
