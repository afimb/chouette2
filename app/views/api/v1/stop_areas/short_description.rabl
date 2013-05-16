object @stop_area
extends "api/v1/trident_objects/short_description" 

[ :name, :area_type, :longitude, :latitude, :long_lat_type].each do |attr|
    attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
node(:parent_object_id) do |stop_area|
  stop_area.parent.objectid 
end unless root_object.parent.nil?

