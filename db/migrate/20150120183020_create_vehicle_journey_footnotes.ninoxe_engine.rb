# This migration comes from ninoxe_engine (originally 20150119160029)
class CreateVehicleJourneyFootnotes < ActiveRecord::Migration
  def change
    create_table :footnotes_vehicle_journeys, :id => false, :force => true do |t|
      t.integer  "vehicle_journey_id", :limit => 8
      t.integer  "footnote_id", :limit => 8
    end
  end
end
