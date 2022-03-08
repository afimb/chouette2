# This migration comes from ninoxe_engine (originally 20140820060801)
class AddZipCodeAndCityNameToStopArea < ActiveRecord::Migration[4.2]
  def change
    change_table :stop_areas do |t|
      t.string :zip_code
      t.string :city_name
    end
  end
end
