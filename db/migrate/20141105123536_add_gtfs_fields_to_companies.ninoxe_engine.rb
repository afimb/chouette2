# This migration comes from ninoxe_engine (originally 20141017075349)
class AddGtfsFieldsToCompanies < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.string :url
      t.string :time_zone
    end
  end
end
