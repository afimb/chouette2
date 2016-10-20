require 'open-uri'

class OsrmRouteSectionProcessor

  def call(route_section)
    @osrm_endpoint = Rails.application.secrets.osrm_endpoint

    @points_string = (route_section.input_geometry || route_section.default_geometry).points.map do |point|
      "loc=#{point.y.to_f},#{point.x.to_f}"
    end.join

    execute_geometry
  end

  def self.create_all
    Chouette::JourneyPattern.find_each do |journey_pattern|
      selector = RouteSectionsSelector.new(journey_pattern)
      selector.sections.each do |section|
        section.create_candidate unless section.candidates.present?
      end
    end
  end

  protected

  def execute_geometry(secondary = false)
    if secondary && Rails.application.secrets.osrm_secondary_endpoint.present?
      @osrm_endpoint = Rails.application.secrets.osrm_secondary_endpoint
    end

    response = open "#{@osrm_endpoint}/viaroute?#{@points_string}instructions=false"
    return nil unless response

    geometry = JSON.parse(response.read.to_s)['route_geometry']
    if geometry
      decoded_geometry = Polylines::Decoder.decode_polyline(geometry, 1e6).map do |point|
        GeoRuby::SimpleFeatures::Point.from_x_y(point[1], point[0], 4326)
      end

      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry).try(:to_rgeo) if decoded_geometry.many?
    end
  rescue => e
    Rails.logger.error "#{@osrm_endpoint} failed: #{e}"
    return !secondary ? execute_geometry(true) : nil
  end

end
