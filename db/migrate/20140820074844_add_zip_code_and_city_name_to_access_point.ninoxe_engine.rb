# This migration comes from ninoxe_engine (originally 20140820060814)
class AddZipCodeAndCityNameToAccessPoint < ActiveRecord::Migration
  def change
    change_table :access_points do |t|
      t.string :zip_code
      t.string :city_name
    end
  end
end
