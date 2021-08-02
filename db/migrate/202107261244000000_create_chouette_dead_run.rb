class CreateChouetteDeadRun < ActiveRecord::Migration
  def up

    connection.execute 'drop table if exists time_tables_dead_runs'
    connection.execute 'drop table if exists dead_run_at_stops'
    connection.execute 'drop table if exists blocks_dead_runs'
    connection.execute 'drop table if exists dead_runs'

    create_table :dead_runs, :force => true do |t|
      t.integer  "journey_pattern_id", :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
    end
   add_index "dead_runs", ["objectid"], :name => "dead_runs_objectid_key", :unique => true
   add_foreign_key "dead_runs", "journey_patterns", column: "journey_pattern_id",  name: "dead_runs_journey_patterns_id_fkey"

    create_table :dead_run_at_stops, :force => true do |t|

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.integer  "dead_run_id", :limit => 8
      t.integer  "stop_point_id", :limit => 8
      t.time "arrival_time"
      t.time "departure_time"
      t.integer "arrival_day_offset"
      t.integer "departure_day_offset"
    end
    add_index "dead_run_at_stops", ["dead_run_id"], :name => "index_dead_run_at_stops_on_dead_run_id"
    add_index "dead_run_at_stops", ["stop_point_id"], :name => "index_dead_run_at_stops_on_stop_pointid"
    add_foreign_key "dead_run_at_stops", "dead_runs", column: "dead_run_id",  name: "dead_run_at_stops_dead_runs_id_fkey"
    add_foreign_key "dead_run_at_stops", "stop_points", column: "stop_point_id",  name: "dead_run_at_stops_stop_point_id_fkey"

    create_table :blocks_dead_runs, :id => false, :force => true do |t|
      t.integer  "block_id"
      t.integer  "dead_run_id"
      t.integer  "position"
    end
    add_index "blocks_dead_runs", ["block_id", "dead_run_id"], :unique => true,
              :name => "blocks_dead_runs_block_id_dead_run_id_key"
    add_index "blocks_dead_runs", ["dead_run_id"], :name => "blocks_dead_runs_dead_run_id_idx"
    add_foreign_key "blocks_dead_runs", "blocks", column: "block_id",  name: "blocks_dead_runs_block_id_fkey"
    add_foreign_key "blocks_dead_runs", "dead_runs", column: "dead_run_id",  name: "blocks_dead_runs_dead_run_id_fkey"


    create_table :time_tables_dead_runs, :id => false, :force => true do |t|
      t.integer  "dead_run_id"
      t.integer  "time_table_id"
    end
    add_index "time_tables_dead_runs", ["time_table_id", "dead_run_id"], :unique => true,
              :name => "time_tables_dead_runs_dead_run_id_time_table_id_key"
    add_index "time_tables_dead_runs", ["dead_run_id"], :name => "time_tables_dead_runs_dead_run_id_idx"
    add_foreign_key "time_tables_dead_runs", "dead_runs", column: "dead_run_id",  name: "time_tables_dead_runs_dead_run_id_fkey"
    add_foreign_key "time_tables_dead_runs", "time_tables", column: "time_table_id",  name: "time_tables_dead_runs_time_table_id_fkey"


  end

end
