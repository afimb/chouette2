object @route
extends "api/v1/trident_objects/show"

attributes :direction_code, :wayback_code, :name
attributes :comment, :opposite_route_id, :published_name, :number, :direction, :wayback

child :line do
  attributes :objectid, :name, :published_name, :number, :registration_number
end

child :journey_patterns do |journey_pattern|
  attributes :objectid, :name, :published_name, :registration_number
end

child :vehicle_journeys do |vj|
 attributes :objectid
end

child :stop_areas do |stop_area|
  attributes :objectid, :name, :area_type, :longitude, :latitude, :long_lat_type
  glue stop_area.parent do
    attributes :objectid => :parent
  end
end
