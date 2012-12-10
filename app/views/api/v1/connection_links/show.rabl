object @connection_link
extends "api/v1/trident_objects/show"

attributes :connection_link_type, :name, :comment
attributes :link_distance, :link_type, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration
attributes :mobility_restricted_traveller_duration, :mobility_restricted_suitability, :stairs_availability, :lift_availability, :int_user_needs

child :departure => :departure do
  attributes :objectid, :name, :area_type, :longitude, :latitude, :long_lat_type
end 
child :arrival => :arrival do
  attributes :objectid, :name, :area_type, :longitude, :latitude, :long_lat_type
end 
