# -*- coding: utf-8 -*-
require "csv"

class VehicleJourneyExport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :vehicle_journeys, :route

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end

  def label(name)
    I18n.t "vehicle_journey_exports.label.#{name}"
  end

  def column_names
    ["", label("vehicle_journey_id")] + vehicle_journeys.collect(&:objectid)
  end

  # produce a map stop_id => departure time for a vehicle_journey
  def time_by_stops(vj)
    {}.tap do |hash|
       vj.vehicle_journey_at_stops.each do |vjas|
         hash[ "#{vjas.stop_point_id}"] = vjas.departure_time.strftime("%H:%M") 
      end
    end
  end

  def time_tables (vj)
    (vj.time_tables.collect{ |t| t.id })
  end

  def time_tables_array
    (vehicle_journeys.collect{ |vj| time_tables(vj).to_s[1..-2] } )
  end

  def vehicle_journey_at_stops_array
    (vehicle_journeys.collect{ |vj| time_by_stops vj } )
  end
  
  def boolean_code(b)
    b.nil? ? "" : label("b_"+b.to_s)
  end

  def number_array
    (vehicle_journeys.collect{ |vj| vj.number ?  vj.number.to_s : "" } )
  end

  def flexible_service_array
    (vehicle_journeys.collect{ |vj| boolean_code vj.flexible_service  } )
  end
  
  def mobility_restricted_suitability_array
    (vehicle_journeys.collect{ |vj| boolean_code vj.mobility_restricted_suitability  } )
  end
  
  def empty_array
    (vehicle_journeys.collect{ |vj| "" } )
  end

  def times_of_stop(stop_id,vjas_array)
    a = []
    vjas_array.each do |map|
      a << (map[stop_id.to_s].present? ? map[stop_id.to_s] : "")
    end
    a
  end
  
  def to_csv(options = {})
    CSV.generate(options) do |csv|            
      csv << column_names
      csv << ["", label("number")] + number_array
      csv << ["", label("mobility")] + mobility_restricted_suitability_array
      csv << ["", label("flexible_service")] + flexible_service_array
      csv << ["", label("time_table_ids")] + time_tables_array
      csv << [label("stop_id"), label("stop_name")] + empty_array
      vjas_array = vehicle_journey_at_stops_array
      route.stop_points.each_with_index do |stop_point, index|        
        times = times_of_stop(stop_point.id,vjas_array)
        csv << [stop_point.id, stop_point.stop_area.name] + times
      end
    end
  end

end
