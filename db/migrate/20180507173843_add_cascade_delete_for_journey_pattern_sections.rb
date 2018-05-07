class AddCascadeDeleteForJourneyPatternSections < ActiveRecord::Migration
  def change
    remove_foreign_key :journey_pattern_sections, :journey_patterns
    add_foreign_key :journey_pattern_sections, :journey_patterns, on_delete: :cascade
  end
end
