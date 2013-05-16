object @route
extends "api/v1/trident_objects/show"

[:name, :published_name, :number, :direction].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end
attributes :opposite_route_id => :way_back_route_id, :unless => lambda { |m| m.opposite_route_id.nil?}
attributes :comment, :unless => lambda { |m| m.comment.nil?}
attributes :wayback => :way_back, :unless => lambda { |m| m.wayback.nil?}

node :line_short_description do |route|
  partial("api/v1/lines/short_description", :object => route.line)
end

child :journey_patterns => :journey_pattern_short_descriptions do |journey_patterns|
  node do |journey|
    partial("api/v1/journey_patterns/short_description", :object => journey) 
  end 
end unless root_object.journey_patterns.empty?

node(:vehicle_journey_object_ids) do |route|
  route.vehicle_journeys.map(&:objectid)
end unless root_object.vehicle_journeys.empty?

child :stop_areas => :stop_area_short_descriptions do |stop_areas|
  node do |stop_area|
    partial("api/v1/stop_areas/short_description", :object => stop_area)
  end 
end unless root_object.stop_areas.empty?
