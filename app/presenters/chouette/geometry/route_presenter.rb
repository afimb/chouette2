class Chouette::Geometry::RoutePresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(route)
    @route = route
  end

  # return route's stop_areas cloud geometry
  #
  def stop_areas_geometry
    to_multi_point_feature( @route.stop_areas.with_geometry )
  end

  # return route geometry based on BoardingPosition or Quay
  #
  def geometry
    to_line_string_feature( @route.stop_areas.with_geometry )
  end


end

