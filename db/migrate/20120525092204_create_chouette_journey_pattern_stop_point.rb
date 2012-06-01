class CreateChouetteJourneyPatternStopPoint < ActiveRecord::Migration
  def up
    create_table :journey_patterns_stop_points, :id => false, :force => true do |t|
      t.integer  "journey_pattern_id", :limit => 8
      t.integer  "stop_point_id", :limit => 8
    end
    add_index "journey_patterns_stop_points", ["journey_pattern_id"], :name => "index_journey_pattern_id_on_journey_patterns_stop_points"
  end

  def down
    remove_index "journey_patterns_stop_points", :name => "index_journey_pattern_id_on_journey_patterns_stop_points"
    drop_table :journey_pattern_stop_points
  end
end
