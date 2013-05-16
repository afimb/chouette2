object @access_point
extends "api/v1/trident_objects/short_description"

[ :name, :access_type, :longitude, :latitude, :long_lat_type].each do |attr|
    attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
node :contained_in_short_description do |access_point|
  partial("api/v1/stop_areas/short_description", :object => access_point.stop_area)
end unless root_object.stop_area.nil?
