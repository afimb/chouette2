object @access_link
extends "api/v1/trident_objects/show"

[ :name].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node :access_point_short_description do |connection|
    partial( "api/v1/access_points/short_description", :object => connection.access_point) unless connection.access_point.nil?
end

node :stop_area_short_description do |connection|
    partial( "api/v1/stop_areas/short_description", :object => connection.stop_area) unless connection.stop_area.nil?
end

[ :link_distance, :link_type, :link_orientation, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration, :mobility_restricted_traveller_duration, :mobility_restricted_suitability , :stairs_availability , :lift_availability, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
