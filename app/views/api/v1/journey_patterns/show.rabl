object @journey_pattern
extends "api/v1/trident_objects/show"

[:name, :published_name, :registration_number, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node(:route_short_description) do |journey_pattern|
  partial("api/v1/routes/short_description", :object => journey_pattern.route)
end

node(:vehicle_journey_object_ids) do |journey_pattern|
  journey_pattern.vehicle_journeys.map(&:objectid)
end unless root_object.vehicle_journeys.empty?

child :stop_points => :stop_area_short_descriptions do |stop_points|
  node do |stop_point|
    partial("api/v1/stop_areas/short_description", :object => stop_point.stop_area) 
  end 
end unless root_object.stop_points.empty? 

