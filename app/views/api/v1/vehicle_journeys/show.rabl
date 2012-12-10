object @vehicle_journey
extends "api/v1/trident_objects/show"

attributes :comment, :status_value
attributes :transport_mode, :published_journey_name, :published_journey_identifier, :facility, :vehicle_type_identifier, :number

child :route do
  attributes :objectid, :name, :published_name, :number, :direction, :wayback
end 

child :journey_pattern do
  attributes :objectid, :name, :published_name, :registration_number
end

child :time_tables do
 attributes :objectid
end

child :vehicle_journey_at_stops do |vjas|
  attributes :position, :connecting_service_id, :boarding_alighting_possibility, :arrival_time, :departure_time, :waiting_time, :elapse_duration, :headway_frequency
  node(:stop_area) do |vjas|
    {:objectid => vjas.stop_point.stop_area.objectid}
  end
end
