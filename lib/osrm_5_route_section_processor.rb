require 'open-uri'

class Osrm_5_RouteSectionProcessor

  def call(route_section)
    @osrm_endpoint = Rails.application.secrets.osrm_endpoint

    @points_string = (route_section.input_geometry || route_section.default_geometry).points.map do |point|
      "#{point.x.to_f},#{point.y.to_f}"
    end.join(';')

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

    path = "#{@osrm_endpoint}/route/v1/driving/#{@points_string}?overview=false&steps=true&geometries=polyline"
    Rails.logger.info "Invoke #{path} for RouteSection"
    response = open path
    return nil unless response

    routes = JSON.parse(response.read.to_s)
    if routes
      decoded_geometry = nil
      routes["routes"].map do |legs|
        legs["legs"].map do |steps|
          steps["steps"].map do |geometry|
            current_points = Polylines::Decoder.decode_polyline(geometry["geometry"], 1e5).map do |point|
              GeoRuby::SimpleFeatures::Point.from_x_y(point[1], point[0], 4326)
            end
            decoded_geometry.nil? ? decoded_geometry = current_points : decoded_geometry.concat(current_points)
          end
        end
      end

      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry).try(:to_rgeo) if decoded_geometry.many?
    end
  rescue => e
    Rails.logger.error "#{@osrm_endpoint} failed: #{e}"
    return !secondary ? execute_geometry(true) : nil
  end
end
