class Chouette::Hub::VehicleJourneyExporter
  include ERB::Util
  attr_accessor :vehicle_journey, :directory, :template
  
  def initialize(vehicle_journey, directory, index)
    @vehicle_journey = vehicle_journey
    @directory = directory
    @template = File.open('app/views/api/hub/courses.hub.erb' ) { |f| f.read }
    @numero = index
    @journey_pattern = Chouette::JourneyPattern.find(@vehicle_journey.journey_pattern_id)
    @route = Chouette::Route.find(@vehicle_journey.route_id)
    @line = Chouette::Line.find(@route.line_id)
    @departure_stop_point = Chouette::StopPoint.find(@journey_pattern.departure_stop_point_id)
    @departure_stop_area =  Chouette::StopArea.find(@departure_stop_point.stop_area_id)
    @arrival_stop_point = Chouette::StopPoint.find(@journey_pattern.arrival_stop_point_id)
    @arrival_stop_area = Chouette::StopArea.find(@arrival_stop_point.stop_area_id)

    #Time.zone = ActiveSupport::TimeZone.new('Atlantic/Azores')
    departure_time = Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => @vehicle_journey.id ).where( :stop_point_id => @departure_stop_point.id )[0].departure_time 
    # Time.zone.parse(Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => @vehicle_journey.id ).where( :stop_point_id => @departure_stop_point.id )[0].departure_time.to_s)
    arrival_time = Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => @vehicle_journey.id ).where( :stop_point_id => @arrival_stop_point.id )[0].arrival_time
    #Time.zone.parse(Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => @vehicle_journey.id ).where( :stop_point_id => @arrival_stop_point.id )[0].arrival_time.to_s)
    
    @departure_time_sec = departure_time.sec + ( departure_time.min + departure_time.hour * 60 ) * 60
    @arrival_time_sec = arrival_time.sec + ( arrival_time.min + arrival_time.hour * 60 ) * 60
    @validity = 0
    #@vehicle_journey.time_tables.map(&:int_day_types).each { |v| @validity |= v }
    @vehicle_journey.time_tables.each { |t| @validity |= ((t.int_day_types / 4) & 127 ) if t.int_day_types }
    
    periods = Chouette::TimeTable.where( :id => @vehicle_journey.time_tables.map(&:id) ).map(&:objectid)
    @periods = ""
    unless periods.empty? 
      @periods += periods[0].sub(/(\w*\:\w*\:)(\w*)/, '\2')
      periods.shift
    end
    unless periods.empty?
      periods.each { |p| @periods += "|" + p.sub(/(\w*\:\w*\:)(\w*)/, '\2') }
    end
    # USE @renvoi for PMR and TAD and create RENVOI.TXT File
    @renvoi = ""
    if @vehicle_journey.mobility_restricted_suitability || @line.mobility_restricted_suitability
      @renvoi = "1"
      File.open(directory + "/RENVOI.TXT" , "a:Windows_1252") do |f|
        if f.size == 0
          f.write("RENVOI\u000D\u000A") 
          f.write("a;PMR;1\u000D\u000A")
        end
      end
    end
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/COURSE.TXT"
  end
  
  def self.save( vehicle_journeys, directory, hub_export)
    vehicle_journeys.each_index do |index|
      self.new( vehicle_journeys[index], directory, index).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_COUNT", :arguments => {"0" => vehicle_journeys.size})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("COURSE\u000D\u000A") if f.size == 0
      f.write(render)
    end if vehicle_journey.present?
  end
end

