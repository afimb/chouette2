# This migration comes from ninoxe_engine (originally 20151204102248)
class AddSectionStatusToJourneyPattern < ActiveRecord::Migration
  def change
    add_column :journey_patterns, :section_status, :integer, null: false, default: 0
  end
end
