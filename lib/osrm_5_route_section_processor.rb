require 'open-uri'

class Osrm_5_RouteSectionProcessor

  def call(route_section)

    # Find transport mode by stop_area
    if route_section.from_scheduled_stop_point.stop_area.transport_mode.present?
      mode = route_section.from_scheduled_stop_point.stop_area.transport_mode.downcase
    end

    # Example configuration from application.yml:
    # osrm_endpoint_list: '{"default": "http://osrm-bus:5000", "water": "http://osrm-ferry:5000", "rail": "http://osrm-railway:5000"}'

    @osrm_endpoint = (!Rails.application.secrets.osrm_endpoint_list.nil? &&         # New configuration of osrm_endpoint_list exists
                        Rails.application.secrets.osrm_endpoint_list[mode])      # AND osrm-endpoint configured for mode

    if @osrm_endpoint.nil?
      Rails.logger.info "OSRM not configured for TransportMode: '#{mode}'"
      return
    end

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

  def execute_geometry()

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
  end
end
