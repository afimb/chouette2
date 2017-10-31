class CreateRoutePoints < ActiveRecord::Migration
  def change
    create_table :route_points do |t|
      t.string   "objectid",                  null: false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.integer "scheduled_stop_point_id"
      t.string   "name"
      t.boolean "boarder_crossing"

    end
    add_index "route_points", ["objectid"], :name => "route_points_objectid_key", :unique => true
    add_foreign_key :route_points, :scheduled_stop_points

    create_table :routes_route_points do |t|
      t.integer "route_id",                   null: false
      t.integer "route_point_id",             null: false
      t.integer "position",                   null: false
    end
    add_foreign_key :routes_route_points, :routes
    add_foreign_key :routes_route_points, :route_points
  end
end
