class AddBlockStartEndPoint < ActiveRecord::Migration
  def change

    add_column :blocks, :start_time, :time, null: true
    add_column :blocks, :end_time, :time, null: true
    add_column :blocks, :end_time_day_offset, :integer, null: true
    add_column :blocks, :start_point_id, :integer, null: true
    add_column :blocks, :end_point_id, :integer, null: true

    add_foreign_key "blocks", "scheduled_stop_points", column: "start_point_id",  name: "blocks_scheduled_stop_points_start_point_id_fkey"
    add_foreign_key "blocks", "scheduled_stop_points", column: "end_point_id",  name: "blocks_scheduled_stop_points_end_point_id_fkey"

    add_index "blocks", ["start_point_id"], :name => "blocks_start_point_id_key"
    add_index "blocks", ["end_point_id"], :name => "blocks_end_point_id_key"

  end
end
