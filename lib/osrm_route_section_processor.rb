require 'open-uri'

class OsrmRouteSectionProcessor

  def call(route_section)
    osrm_endpoint = Rails.application.secrets.osrm_endpoint

    points_string = (route_section.input_geometry || route_section.default_geometry).points.map do |point|
      "#{point.x.to_f},#{point.y.to_f};"
    end.join

    # Remove trailing ';'
    points_string = points_string.chop

    Rails.logger.info "Invoke #{osrm_endpoint} for RouteSection StopArea:#{route_section.departure.id} -> StopArea:#{route_section.arrival.id}"

    profile = 'car'

    response = open "#{osrm_endpoint}/route/v1/#{profile}/#{points_string}?overview=false&steps=true&geometries=polyline"
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

              if decoded_geometry.nil?
                decoded_geometry = current_points
              else
                decoded_geometry.concat(current_points)
              end
            end
          end
        end

      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry).try(:to_rgeo) if decoded_geometry.many?
    end
  rescue OpenURI::HTTPError => e
    Rails.logger.error "#{osrm_endpoint} failed: #{e}"
    nil
  rescue IOError => e
    Rails.logger.error "#{osrm_endpoint} failed: #{e}"
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
