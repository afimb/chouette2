module Chouette::Geometry::GeneralPresenter

  def to_line_string_feature( stop_areas)
    points = stop_areas.collect(&:geometry).compact
    GeoRuby::SimpleFeatures::LineString.from_points(points)
  end

  def to_multi_point_feature( stop_areas)
    points = stop_areas.collect(&:geometry).compact
    GeoRuby::SimpleFeatures::MultiPoint.from_points( points )
  end

  def to_point_feature( stop_area)
    return nil unless stop_area.longitude && stop_area.latitude
    GeoRuby::SimpleFeatures::Point.from_lon_lat( stop_area.longitude, stop_area.latitude, 4326)
  end

end


