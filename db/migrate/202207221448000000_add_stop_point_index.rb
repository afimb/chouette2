class AddStopPointIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "stop_points", ["route_id"], :name => "stop_points_route_id_idx"
    add_index "stop_points", ["scheduled_stop_point_id"], :name => "stop_points_scheduled_stop_point_id_idx"
  end

  def down
    remove_index "stop_points", :name => "stop_points_route_id_idx" if index_name_exists?(:stop_points, :stop_points_route_id_idx)
    remove_index "stop_points", :name => "stop_points_scheduled_stop_point_id_idx" if index_name_exists?(:stop_points, :stop_points_scheduled_stop_point_id_idx)
  end

end