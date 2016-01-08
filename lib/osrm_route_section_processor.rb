require 'open-uri'

class OsrmRouteSectionProcessor

  def call(route_section)
    points_string = (route_section.input_geometry || route_section.default_geometry).points.map do |point|
      "loc=#{point.y.to_f},#{point.x.to_f}"
    end.join

    Rails.logger.info "Invoke router.project-osrm.org for RouteSection StopArea:#{route_section.departure.id} -> StopArea:#{route_section.arrival.id}"

    response = open "http://router.project-osrm.org/viaroute?#{points_string}instructions=false"
    geometry = JSON.parse(response.read.to_s)['route_geometry']

    if geometry
      decoded_geometry = Polylines::Decoder.decode_polyline(geometry, 1e6).map do |point|
        GeoRuby::SimpleFeatures::Point.from_x_y(point[1], point[0], 4326)
      end

      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry).try(:to_rgeo) if decoded_geometry.many?
    end
  rescue OpenURI::HTTPError => e
    Rails.logger.error "router.project-osrm.org failed: #{e}"
    nil
  rescue IOError => e
    Rails.logger.error "router.project-osrm.org failed: #{e}"
    nil
  end

  def self.create_all
    Chouette::JourneyPattern.find_each do |journey_pattern|
      selector = RouteSectionsSelector.new(journey_pattern)
      selector.sections.each do |section|
        section.create_candidate unless section.candidates.present?
      end
    end
  end

end
