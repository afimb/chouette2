# -*- coding: utf-8 -*-

class VehicleJourneyImport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :file, :route
  attr_accessor :created_vehicle_journey_count,:updated_vehicle_journey_count,:deleted_vehicle_journey_count
  attr_accessor :created_journey_pattern_count,:error_count
  
  validates_presence_of :file
  validates_presence_of :route

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) } if attributes
    self.created_vehicle_journey_count = 0
    self.updated_vehicle_journey_count = 0
    self.created_journey_pattern_count = 0
    self.deleted_vehicle_journey_count = 0
    self.error_count = 0
  end
  
  def persisted?
    false
  end
  
  def save
    begin
      Chouette::VehicleJourney.transaction do        
        if imported_vehicle_journeys.map(&:valid?).all? 
          imported_vehicle_journeys.each(&:save!)
          true
        else
          imported_vehicle_journeys.each_with_index do |imported_vehicle_journey, index|
            imported_vehicle_journey.errors.full_messages.each do |message|
              errors.add :base, I18n.t("vehicle_journey_imports.errors.invalid_vehicle_journey", :column => index+1, :message => message)
            end
          end
          raise
        end
      end
    rescue Exception => exception
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace)
      errors.add :base, I18n.t("vehicle_journey_imports.errors.exception")
      false
    end
  end   
  
  def imported_vehicle_journeys
    @imported_vehicle_journeys ||= load_imported_vehicle_journeys
  end

  # Find journey pattern on stop points used in vehicle journey at stops
  # if no stop_point used found, return nil to delete vehicle_journey if exists
  # if only 1 stop_point used found, raise exception to stop import
  def find_journey_pattern_schedule(column,hours_by_stop_point_ids)
    stop_points_used = hours_by_stop_point_ids.reject{ |key,value| value == nil }.keys
    return nil if stop_points_used.empty?

    if stop_points_used.length == 1
      errors.add :base, I18n.t("vehicle_journey_imports.errors.one_stop_point_used", :column => column)
      raise 
    end
    
    journey_pattern_founded = route.journey_patterns.select{ |jp| jp.stop_points.collect(&:id) == stop_points_used }.first
    
    # If no journey pattern founded, create a new one
    self.created_journey_pattern_count += 1  if journey_pattern_founded.nil?
    journey_pattern_founded ? journey_pattern_founded :  route.journey_patterns.create(:stop_points => Chouette::StopPoint.find(stop_points_used) )
  end
  
  def as_integer(v)
    v.blank? ? nil : v.to_i
  end
  
  def as_boolean(v)
    v.blank? ? nil : (v[1..1].downcase != "n")
  end
  
  def update_time_tables(vj,tm_ids)
    vj.time_tables.clear
    return unless tm_ids.present?
    ids = tm_ids.split(",").map(&:to_i)
    vj.time_tables << Chouette::TimeTable.where(:id => ids)
  end
  
  def update_footnotes(vj,ftn_ids)
    vj.footnotes.clear
    return unless ftn_ids.present?
    ids = ftn_ids.split(",").map(&:to_i)
    vj.footnotes << Chouette::Footnote.where(:id => ids, :line_id => vj.route.line.id)
  end

  def load_imported_vehicle_journeys
    
    spreadsheet = open_spreadsheet(file)
    
    vehicle_journeys = []
    
    first_column = spreadsheet.column(1)
    
    # fixed rows (first = 1)
    number_row = 2
    published_journey_name_row = 3
    mobility_row = 4
    flexible_service_row = 5
    time_tables_row = 6
    footnotes_row = 7

    # rows in column (first = 0)
    first_stop_row_index = 8
    
    stop_point_ids = first_column[first_stop_row_index..spreadsheet.last_row].map(&:to_i)
    # blank lines at end of file will produce id = 0 ; ignore them
    last_stop_row_index = stop_point_ids.length + 7
    while stop_point_ids.last == 0
      stop_point_ids = stop_point_ids[0..-2]
      last_stop_row_index -= 1
    end
    
    unless route.stop_points.collect(&:id) == stop_point_ids
      errors.add :base, I18n.t("vehicle_journey_imports.errors.not_same_stop_points", :route => route.id)
      raise
    end    
           
    (3..spreadsheet.last_column).each do |i|
      vehicle_journey_id = spreadsheet.column(i)[0]
      hours_by_stop_point_ids = Hash[[stop_point_ids, spreadsheet.column(i)[first_stop_row_index..last_stop_row_index]].transpose]
      
      journey_pattern = find_journey_pattern_schedule(i,hours_by_stop_point_ids)
      
      vehicle_journey = route.vehicle_journeys.where(:id => vehicle_journey_id, :route_id => route.id).first_or_initialize

      if journey_pattern.nil?
        if vehicle_journey.id.present? 
          self.deleted_vehicle_journey_count += 1
          vehicle_journey.delete
        end
        next
      end
      if vehicle_journey.id.present? 
        self.updated_vehicle_journey_count += 1
      else
        self.created_vehicle_journey_count += 1
      end
      
      # number
      vehicle_journey.number = as_integer(spreadsheet.row(number_row)[i-1])
      
      # published_name
      vehicle_journey.published_journey_name = spreadsheet.row(published_journey_name_row)[i-1]
      
      # flexible_service
      vehicle_journey.flexible_service = as_boolean(spreadsheet.row(flexible_service_row)[i-1])
      
      # mobility
      vehicle_journey.mobility_restricted_suitability = as_boolean(spreadsheet.row(mobility_row)[i-1])
      
      # time_tables
      update_time_tables(vehicle_journey,spreadsheet.row(time_tables_row)[i-1])
      
      update_footnotes(vehicle_journey,spreadsheet.row(footnotes_row)[i-1])
      
      # journey_pattern
      vehicle_journey.journey_pattern = journey_pattern
      vehicle_journey.vehicle_journey_at_stops.clear

      line = 0
      hours_by_stop_point_ids.each_pair do |key, value|
        line += 1
        if value.present? # Create a vehicle journey at stop when time is present
          begin 
            # force UTC to ignore timezone effects
            main_time = Time.parse(value+" UTC")
            if main_time.present?
              vjas = Chouette::VehicleJourneyAtStop.new(:stop_point_id => key, :vehicle_journey_id => vehicle_journey.id, :departure_time => main_time, :arrival_time => main_time )
              vehicle_journey.vehicle_journey_at_stops << vjas
            end
          rescue Exception => exception
            errors.add :base, I18n.t("vehicle_journey_imports.errors.invalid_vehicle_journey_at_stop", :column => i, :line => line, :time => value)
            raise exception
          end
        end         
      end
      vehicle_journey.recalculate_offset = true
      vehicle_journeys << vehicle_journey
    end
    
    vehicle_journeys
  end
  
  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path, csv_options: {col_sep: ";"})
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end
end
