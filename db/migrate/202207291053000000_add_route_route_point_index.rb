class AddRouteRoutePointIndex < ActiveRecord::Migration[5.2]
  def up
    add_index "routes_route_points", ["route_id"], :name => "routes_route_points_route_id_idx"
    add_index "routes_route_points", ["route_point_id"], :name => "routes_route_points_route_point_id_idx"
  end

  def down
    remove_index "routes_route_points", :name => "routes_route_points_route_id_idx" if index_name_exists?(:routes_route_points, :routes_route_points_route_id_idx)
    remove_index "routes_route_points", :name => "routes_route_points_route_point_id_idx" if index_name_exists?(:routes_route_points, :routes_route_points_route_point_id_idx)
  end

end