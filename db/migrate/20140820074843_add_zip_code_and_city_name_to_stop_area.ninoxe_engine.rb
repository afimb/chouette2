# This migration comes from ninoxe_engine (originally 20140820060801)
class AddZipCodeAndCityNameToStopArea < ActiveRecord::Migration
  def change
    change_table :stop_areas do |t|
      t.string :zip_code
      t.string :city_name
    end
  end
end
