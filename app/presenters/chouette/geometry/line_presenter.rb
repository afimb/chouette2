class Chouette::Geometry::LinePresenter
  include Chouette::Geometry::GeneralPresenter

  def initialize(line)
    @line = line
  end

  # return line geometry based on CommercialStopPoint
  #
  def geometry
    features = commercial_links.map { |link| to_line_string_feature(link) }
    GeoRuby::SimpleFeatures::MultiLineString.from_line_strings( features, 4326)
  end
  #
  # return line's stop_areas cloud geometry
  #
  def stop_areas_geometry
    to_multi_point_feature( @line.commercial_stop_areas)
  end

  def commercial_links
    link_keys = []
    [].tap do |stop_area_links|
      @line.routes.each do |route|
        previous_commercial = nil
        routes_localized_commercials(route).each do |commercial|
          if previous_commercial && !link_keys.include?( "#{previous_commercial.id}-#{commercial.id}")
            stop_area_links << [ previous_commercial, commercial]
            link_keys << "#{previous_commercial.id}-#{commercial.id}"
            link_keys << "#{commercial.id}-#{previous_commercial.id}"
          end
          previous_commercial = commercial
        end
      end
    end
  end

  def routes_localized_commercials(route)
    route.stop_areas.map { |sa| sa.parent}.compact.select { |sa| sa.latitude && sa.longitude}
  end

end
