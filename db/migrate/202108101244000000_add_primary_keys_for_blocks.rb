class AddPrimaryKeysForBlocks < ActiveRecord::Migration[4.2]
  def up
    execute "ALTER TABLE blocks_dead_runs ADD PRIMARY KEY (block_id, dead_run_id);"
    execute "ALTER TABLE blocks_vehicle_journeys ADD PRIMARY KEY (block_id, vehicle_journey_id);"
    execute "ALTER TABLE time_tables_blocks ADD PRIMARY KEY (time_table_id, block_id);"
    execute "ALTER TABLE time_tables_dead_runs ADD PRIMARY KEY (time_table_id, dead_run_id);"

    # Remove redundant indexes
    remove_index :blocks_vehicle_journeys, name: "blocks_vehicle_journeys_block_id_vehicle_journey_id_key" if index_name_exists?(:blocks_vehicle_journeys, :blocks_vehicle_journeys_block_id_vehicle_journey_id_key, quoted_true)
    remove_index :blocks_dead_runs, name: "blocks_dead_runs_block_id_dead_run_id_key" if index_name_exists?(:blocks_dead_runs, :blocks_dead_runs_block_id_dead_run_id_key, quoted_true)
    remove_index :time_tables_blocks, name: "time_tables_blocks_block_id_time_table_id_key" if index_name_exists?(:time_tables_blocks, :time_tables_blocks_block_id_time_table_id_key, quoted_true)
    remove_index :time_tables_dead_runs, name: "time_tables_dead_runs_dead_run_id_time_table_id_key" if index_name_exists?(:time_tables_dead_runs, :time_tables_dead_runs_dead_run_id_time_table_id_key, quoted_true)

  end

  def down
    execute "ALTER TABLE blocks_dead_runs DROP CONSTRAINT blocks_dead_runs_pkey;"
    execute "ALTER TABLE blocks_vehicle_journeys DROP CONSTRAINT blocks_vehicle_journeys_pkey;"
    execute "ALTER TABLE time_tables_blocks DROP CONSTRAINT time_tables_blocks_pkey;"
    execute "ALTER TABLE time_tables_dead_runs DROP CONSTRAINT time_tables_dead_runs_pkey;"

    # Add back redundant indexes
    add_index "blocks_vehicle_journeys", ["block_id", "vehicle_journey_id"], name: "blocks_vehicle_journeys_block_id_vehicle_journey_id_key", unique: true, using: :btree unless index_name_exists?(:blocks_vehicle_journeys, :blocks_vehicle_journeys_block_id_vehicle_journey_id_key, quoted_true)
    add_index "blocks_dead_runs", ["block_id", "dead_run_id"], name: "blocks_dead_runs_block_id_dead_run_id_key", unique: true, using: :btree unless index_name_exists?(:blocks_dead_runs, :blocks_dead_runs_block_id_dead_run_id_key, quoted_true)
    add_index "time_tables_blocks", ["time_table_id", "block_id"], name: "time_tables_blocks_block_id_time_table_id_key", unique: true, using: :btree unless index_name_exists?(:time_tables_blocks, :time_tables_blocks_block_id_time_table_id_key, quoted_true)
    add_index "time_tables_dead_runs", ["time_table_id", "dead_run_id"], name: "time_tables_dead_runs_dead_run_id_time_table_id_key", unique: true, using: :btree unless index_name_exists?(:time_tables_dead_runs, :time_tables_dead_runs_dead_run_id_time_table_id_key, quoted_true)
  end
end


