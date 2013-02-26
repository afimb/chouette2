object @access_link
extends "api/v1/trident_objects/show"

[:access_point_id , :comment , :creation_time , :creator_id , :default_duration , :frequent_traveller_duration , :int_user_needs , :lift_availability , :link_distance , :link_orientation , :link_type , :mobility_restricted_suitability , :mobility_restricted_traveller_duration , :name ,  :occasional_traveller_duration , :stairs_availability , :stop_area_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
