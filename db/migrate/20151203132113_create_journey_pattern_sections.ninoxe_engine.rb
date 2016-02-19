# This migration comes from ninoxe_engine (originally 20151203131606)
class CreateJourneyPatternSections < ActiveRecord::Migration
  def change
    create_table :journey_pattern_sections do |t|
      t.references :journey_pattern, null: false, index: true, limit: 8
      t.references :route_section, null: false, index: true, limit: 8
      t.integer :rank, null: false
      t.foreign_key :journey_patterns, dependent: :delete
      t.foreign_key :route_sections, dependent: :delete

      t.timestamps
    end
    add_index :journey_pattern_sections, [:journey_pattern_id, :route_section_id, :rank],
              unique: true, name: 'index_jps_on_journey_pattern_id_and_route_section_id_and_rank'
  end
end
