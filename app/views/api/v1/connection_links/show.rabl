object @connection_link
extends "api/v1/trident_objects/show"

[ :name, :link_distance, :link_type, :default_duration, 
  :frequent_traveller_duration, :occasional_traveller_duration, :mobility_restricted_traveller_duration, 
  :mobility_restricted_suitability, :stairs_availability, :lift_availability, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node :start_of_link_short_description do |connection|
  partial("api/v1/stop_areas/short_description", :object => connection.departure) unless connection.departure.nil?
end

node :end_of_link_short_description do |connection|
  partial("api/v1/stop_areas/short_description", :object => connection.arrival) unless connection.arrival.nil?
end
