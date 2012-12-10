object @journey_pattern
extends "api/v1/trident_objects/show"

attributes :name, :comment, :registration_number
attributes :published_name 

child :route do
  attributes :objectid, :name, :published_name, :number, :direction, :wayback
end 
child :vehicle_journeys do |vj|
 attributes :objectid
end
child :stop_points => :stop_areas do |stop_point|
  node(:stop_area) do |n|
    { :objectid => n.stop_area.objectid, :name => n.stop_area.name,
      :parent => n.stop_area.parent.objectid,
      :area_type => n.stop_area.area_type, 
      :longitude => n.stop_area.longitude, :latitude => n.stop_area.latitude, 
      :long_lat_type => n.stop_area.long_lat_type}
  end
end

