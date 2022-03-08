class AddBlocks < ActiveRecord::Migration[4.2]
  def change
    create_table :blocks, :force => true do |t|
      t.string   "objectid",                  null: false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.string   "private_code"
      t.string   "name"
      t.string   "description"
    end
    add_index "blocks", ["objectid"], :name => "blocks_objectid_key", :unique => true

    create_table :blocks_vehicle_journeys, :id => false, :force => true do |t|
      t.integer  "block_id"
      t.integer  "vehicle_journey_id"
      t.integer  "position"
    end
    add_index "blocks_vehicle_journeys", ["block_id", "vehicle_journey_id"], :unique => true,
              :name => "blocks_vehicle_journeys_block_id_vehicle_journey_id_key"
    add_index "blocks_vehicle_journeys", ["vehicle_journey_id"], :name => "blocks_vehicle_journeys_vehicle_journey_id_idx"
    add_foreign_key "blocks_vehicle_journeys", "blocks", column: "block_id",  name: "blocks_vehicle_journeys_block_id_fkey"
    add_foreign_key "blocks_vehicle_journeys", "vehicle_journeys", column: "vehicle_journey_id",  name: "blocks_vehicle_journeys_vehicle_journey_id_fkey"

    create_table :time_tables_blocks, :id => false, :force => true do |t|
      t.integer  "block_id"
      t.integer  "time_table_id"
    end
    add_index "time_tables_blocks", ["time_table_id", "block_id"], :unique => true,
              :name => "time_tables_blocks_block_id_time_table_id_key"
    add_index "time_tables_blocks", ["block_id"], :name => "time_tables_blocks_block_id_idx"
    add_foreign_key "time_tables_blocks", "blocks", column: "block_id",  name: "time_tables_blocks_block_id_fkey"
    add_foreign_key "time_tables_blocks", "time_tables", column: "time_table_id",  name: "time_tables_blocks_time_table_id_fkey"

  end
end
