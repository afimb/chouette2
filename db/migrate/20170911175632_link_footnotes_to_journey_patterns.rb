class LinkFootnotesToJourneyPatterns < ActiveRecord::Migration[4.2]
  def change
    create_table :footnotes_journey_patterns, :id => false, :force => true do |t|
      t.integer  "journey_pattern_id"
      t.integer  "footnote_id"
    end
    add_index "footnotes_journey_patterns", ["journey_pattern_id"], :name => "footnotes_journey_patterns_id_idx"
    add_index "footnotes_journey_patterns", ["footnote_id"], :name => "footnotes_id_journey_patterns_id_idx"
  end
end
