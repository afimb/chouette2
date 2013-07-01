object @access_point
extends "api/v1/trident_objects/show"

[ :longitude, :latitude, :long_lat_type, :street_name, :country_code, 
    :projection_x , :projection_y , :projection, :name, :access_type, 
    :openning_time, :closing_time, 
    :mobility_restricted_suitability, :stairs_availability, :lift_availability, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
node :contained_in_short_description do |access_point|
  partial("api/v1/stop_areas/short_description", :object => access_point.stop_area)
end unless root_object.stop_area.nil?
