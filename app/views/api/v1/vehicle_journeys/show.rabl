object @vehicle_journey
extends "api/v1/trident_objects/show"

[ :published_journey_name, :published_journey_identifier, :transport_mode, :vehicle_type_identifier, :status_value, :facility, :number, :comment].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

node(:route_short_description) do |vehicle|
  partial("api/v1/routes/short_description", :object => vehicle.route)
end

node(:journey_pattern_short_description) do |vehicle|
  partial("api/v1/routes/short_description", :object => vehicle.journey_pattern)
end

node(:time_table_object_ids) do |vehicle|
  vehicle.time_tables.map(&:objectid)
end unless root_object.time_tables.empty?

child :vehicle_journey_at_stops do |vehicle_stops|
  node do |vehicle_stop|
    node(:stop_area_object_id) { vehicle_stop.stop_point.stop_area.objectid }

    [ :connecting_service_id, :arrival_time, :departure_time, :boarding_alighting_possibility, :arrival_day_offset , :departure_day_offset , :for_boarding, :for_alighting].each do |attr|
      node( attr) do
        vehicle_stop.send(attr) 
      end unless vehicle_stop.send(attr).nil?
    end
    attributes :order => vehicle_stop.stop_point.position, :unless => lambda { |m| m.send( :position).nil?}
  end
end
