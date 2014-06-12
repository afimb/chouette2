# -*- coding: utf-8 -*-
require "csv"

class VehicleJourneyExport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :route
  
  validates_presence_of :route

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def to_csv(options = {})
    CSV.generate(options) do |csv|
      vehicle_journeys_sorted = route.vehicle_journeys.includes(:vehicle_journey_at_stops).order("vehicle_journey_at_stops.departure_time")
      
      vehicle_journey_at_stops_matrix = (vehicle_journeys_sorted.collect{ |vj| vj.vehicle_journey_at_stops.collect(&:departure_time).collect{|time| time.strftime("%H:%M")} }).transpose
      csv << ["stop_point_id", "stop_area_name"] + vehicle_journeys_sorted.collect(&:objectid)
      route.stop_points.each_with_index do |stop_point, index|
        csv << [stop_point.id, stop_point.stop_area.name] + vehicle_journey_at_stops_matrix[index]
      end
    end
  end

end
