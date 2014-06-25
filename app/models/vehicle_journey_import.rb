# -*- coding: utf-8 -*-

class VehicleJourneyImport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :file, :route
  
  validates_presence_of :file
  validates_presence_of :route

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
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
              errors.add :base, I18n.t("vehicle_journey_imports.errors.invalid_vehicle_journey", :column => index, :message => message)
            end
          end
          false
        end
      end
    rescue Exception => exception
      errors.add :base, I18n.t("vehicle_journey_imports.errors.exception", :message => exception.message)
      false
    end
  end   
  
  def imported_vehicle_journeys
    @imported_vehicle_journeys ||= load_imported_vehicle_journeys
  end

  # Find journey pattern on stop points used in vehicle journey at stops
  def find_journey_pattern_schedule(hours_by_stop_point_ids)
    stop_points_used = hours_by_stop_point_ids.reject{ |key,value| value == nil }.keys
    journey_pattern_founded = route.journey_patterns.select{ |jp| jp.stop_points.collect(&:id) == stop_points_used }.first
    
    # If no journey pattern founded, create a new one
    journey_pattern_founded ? journey_pattern_founded : route.journey_patterns.create(:stop_points => Chouette::StopPoint.find(stop_points_used) )
  end

  def load_imported_vehicle_journeys
    spreadsheet = open_spreadsheet(file)
    vehicle_journeys = []
    
    first_column = spreadsheet.column(1)
    stop_point_ids = first_column[1..spreadsheet.last_row].map(&:to_i)
    same_stop_points = route.stop_points.collect(&:id) == stop_point_ids
    
    unless same_stop_points
      errors.add :base, I18n.t("vehicle_journey_imports.errors.not_same_stop_points", :route => route.id)
      return vehicle_journeys
    end    
    
    Chouette::VehicleJourney.transaction do       
      (3..spreadsheet.last_column).each do |i|
        vehicle_journey_objectid = spreadsheet.column(i)[0]
        hours_by_stop_point_ids = Hash[[stop_point_ids, spreadsheet.column(i)[1..spreadsheet.last_row]].transpose]
        
        journey_pattern = find_journey_pattern_schedule(hours_by_stop_point_ids)
        #puts "journey_pattern #{journey_pattern.inspect}"
        vehicle_journey = journey_pattern.vehicle_journeys.where(:objectid => vehicle_journey_objectid, :route_id => route.id, :journey_pattern_id => journey_pattern.id).first_or_create
        #puts "vehicle_journey #{vehicle_journey.inspect}"

        line = 0
        hours_by_stop_point_ids.each_pair do |key, value|
          line += 1
          if value.present? # Create a vehicle journey at stop when time is present
            main_time = Time.parse(value)
            if main_time.present?
              vjas = Chouette::VehicleJourneyAtStop.where(:vehicle_journey_id => vehicle_journey.id, :stop_point_id => key).first_or_create(:departure_time => main_time, :arrival_time => main_time)
              #puts "vjas #{vjas.inspect}"
            else
              errors.add :base, I18n.t("vehicle_journey_imports.errors.invalid_vehicle_journey", :column => i, :line => line, :time => value)
            end
          end         
        end
        
        vehicle_journeys << vehicle_journey
      end
    end

    vehicle_journeys
  end
  
  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end
