# This migration comes from ninoxe_engine (originally 20151215175245)
class AddLimitAndForeignKeyToJourneyFrequencies < ActiveRecord::Migration[4.2]
  def up
    change_column :journey_frequencies, :vehicle_journey_id, :integer, limit: 8
    change_column :journey_frequencies, :timeband_id, :integer, limit: 8
    add_foreign_key :journey_frequencies, :vehicle_journeys, dependent: :nullify
    add_foreign_key :journey_frequencies, :timebands, dependent: :nullify
  end

  def down
    change_column :journey_frequencies, :vehicle_journey_id, :integer, limit: 4
    change_column :journey_frequencies, :timeband_id, :integer, limit: 4
    remove_foreign_key :journey_frequencies, :vehicle_journeys
    remove_foreign_key :journey_frequencies, :timebands
  end
end
