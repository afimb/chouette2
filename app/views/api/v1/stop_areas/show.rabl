object @stop_area
extends "api/v1/trident_objects/show"

attributes :routing_stop_ids, :routing_line_ids
attributes :name, :comment, :area_type, :registration_number
attributes :nearest_topic_name, :fare_code, :longitude, :latitude, :long_lat_type, :x, :y, :projection_type
attributes :country_code, :street_name

child :parent => :parent do
  attributes :objectid, :name, :area_type, :longitude, :latitude, :long_lat_type
end
