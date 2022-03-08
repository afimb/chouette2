# This migration comes from ninoxe_engine (originally 20151028105340)
class AddTimebandIdToJourneyFrequencies < ActiveRecord::Migration[4.2]
  def change
    add_reference :journey_frequencies, :timeband, index: true
  end
end
