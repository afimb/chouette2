
module Chouette
  class RoutesRoutePoint < ActiveRecord

    self.primary_key = "id"
    self.table_name = "routes_route_points"
    belongs_to :route_point
    accepts_nested_attributes_for :route_point, :allow_destroy => :true

  end
end
