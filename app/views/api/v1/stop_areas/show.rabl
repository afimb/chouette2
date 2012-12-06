object @stop_area
extends "api/v1/trident_objects/show"

attributes :routing_stop_ids, :routing_line_ids
attributes :name, :comment, :area_type, :registration_number
attributes :nearest_topic_name, :fare_code, :longitude, :latitude, :long_lat_type, :x, :y, :projection_type
attributes :country_code, :street_name

child :parent => :parent do
  attributes :objectid, :name, :area_type, :longitude, :latitude, :long_lat_type
end

child :children_in_depth => :children do |stop_area|
  node(:stop_area) do |n|
    { :objectid => n.stop_area.objectid, :name => n.stop_area.name,
      :parent => n.stop_area.parent.objectid, 
      :area_type => n.stop_area.area_type, 
      :longitude => n.stop_area.longitude, :latitude => n.stop_area.latitude, 
      :long_lat_type => n.stop_area.long_lat_type}
  end
end
