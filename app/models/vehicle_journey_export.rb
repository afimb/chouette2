# -*- coding: utf-8 -*-
require "csv"
require "zip"

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
    ["", label("vehicle_journey_id")] + vehicle_journeys.collect(&:id)
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

  def footnotes (vj)
    (vj.footnotes.collect{ |f| f.id })
  end

  def time_tables_array
    (vehicle_journeys.collect{ |vj| time_tables(vj).to_s[1..-2] } )
  end
  
  def footnotes_array
    (vehicle_journeys.collect{ |vj| footnotes(vj).to_s[1..-2] } )
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

  def published_journey_name_array
    (vehicle_journeys.collect{ |vj| vj.published_journey_name ?  vj.published_journey_name : "" } )
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
      csv << ["", label("published_journey_name")] + published_journey_name_array
      csv << ["", label("mobility")] + mobility_restricted_suitability_array
      csv << ["", label("flexible_service")] + flexible_service_array
      csv << ["", label("time_table_ids")] + time_tables_array
      csv << ["", label("footnotes_ids")] + footnotes_array
      csv << [label("stop_id"), label("stop_name")] + empty_array
      vjas_array = vehicle_journey_at_stops_array
      route.stop_points.each_with_index do |stop_point, index|        
        times = times_of_stop(stop_point.id,vjas_array)
        csv << [stop_point.id, stop_point.stop_area.name] + times
      end
    end
  end

  def tt_day_types(tt)
    type = tt.monday ? label("monday") : ".."
    type += tt.tuesday ? label("tuesday") : ".."
    type += tt.wednesday ? label("wednesday") : ".."
    type += tt.thursday ? label("thursday") : ".."
    type += tt.friday ? label("friday") : ".."
    type += tt.saturday ? label("saturday") : ".."
    type += tt.sunday ? label("sunday") : ".."
    type
  end
  
  def tt_periods(tt)
    periods = ""
    tt.periods.each do |p|
      periods += "["+p.period_start.to_s+" -> "+p.period_end.to_s+"] "
    end
    periods
  end
  
  def tt_peculiar_days(tt)
    days = ""
    tt.included_days.each do |d|
      days += d.to_s+" "
    end
    days
  end 
     
  def tt_excluded_days(tt)
    days = ""
    tt.excluded_days.each do |d|
      days += d.to_s+" "
    end
    days
  end    
  
  def tt_data(tt)
    [].tap do |array|
      # code;name;tags;start;end;day types;periods;peculiar days;excluded days
      array << tt.id.to_s
      array << tt.comment
      array << tt.tag_list
      array << tt.start_date.to_s
      array << tt.end_date.to_s
      array << tt_day_types(tt)
      array << tt_day_types(tt)
      array << tt_periods(tt)
      array << tt_peculiar_days(tt)
      array << tt_excluded_days(tt)
    end  
  end
  
  def time_tables_to_csv (options = {})
    tts = Chouette::TimeTable.all
    CSV.generate(options) do |csv|            
      csv << label("tt_columns").split(";")
      tts.each do |tt|        
        csv << tt_data(tt)
      end
    end
  end

  def ftn_data(ftn)
    [].tap do |array|
      # id;code;label
      array << ftn.id.to_s
      array << ftn.code
      array << ftn.label
    end  
  end
  
  def footnotes_to_csv(options = {})
    footnotes = route.line.footnotes
    CSV.generate(options) do |csv|            
      csv << label("ftn_columns").split(";")
      footnotes.each do |ftn|        
        csv << ftn_data(ftn)
      end
    end
    
  end
  
  def to_zip(temp_file,options = {})
    ::Zip::OutputStream.open(temp_file) { |zos| }
    ::Zip::File.open(temp_file.path, ::Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream(label("vj_filename")+route.id.to_s+".csv") { |f| f.puts to_csv(options) }
      zipfile.get_output_stream(label("tt_filename")+".csv") { |f| f.puts time_tables_to_csv(options) }
      zipfile.get_output_stream(label("ftn_filename")+".csv") { |f| f.puts footnotes_to_csv(options) }
    end    
  end

end
