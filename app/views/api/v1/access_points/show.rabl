object @access_point
extends "api/v1/trident_objects/show"

[ :name, :comment, :longitude, :latitude, :long_lat_type, 
    :x , :y , :projection_type, :country_code, :street_name, :contained_in, 
    :openning_time, :closing_time, :access_type, :lift_availability,
    :mobility_restricted_suitability, :stairs_availability, :stop_area_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
