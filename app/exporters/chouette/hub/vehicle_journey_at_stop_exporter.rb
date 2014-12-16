class Chouette::Hub::VehicleJourneyAtStopExporter
  include ERB::Util
  attr_accessor :vehicle_journey_at_stop, :directory, :template
  
  def initialize(vehicle_journey_at_stop, directory, index, id)
    @vehicle_journey_at_stop = vehicle_journey_at_stop
    @directory = directory
    @vehicle_journey_num = index
    @id = id
    @template = File.open('app/views/api/hub/horaires.hub.erb' ) { |f| f.read }
    stop_point = @vehicle_journey_at_stop.stop_point
    stop_area = stop_point.stop_area
    @stop_area_code = stop_area.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2') if stop_area
    @stop_area_id = stop_area.registration_number if stop_area
    #Time.zone = ActiveSupport::TimeZone.new('Atlantic/Azores')
    arrival_time = @vehicle_journey_at_stop.arrival_time
    @arrival_time = arrival_time.sec + 60 * arrival_time.min + 60 * 60 * arrival_time.hour if arrival_time
    @arrival_type = "A"
    departure_time = @vehicle_journey_at_stop.departure_time
    @departure_time = departure_time.sec + 60 *  departure_time.min + 60 * 60 *  departure_time.hour if departure_time
    @departure_type = "D"
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/HORAIRE.TXT"
  end
  
  def self.save( vehicle_journeys, directory, hub_export, vehicle_journey_at_stops_count)
    id = 1
    vehicle_journeys.each_index do |index|
      vehicle_journey_at_stops = Chouette::VehicleJourneyAtStop.where( :vehicle_journey_id => vehicle_journeys[index].id ).order(:arrival_time)
      vehicle_journey_at_stops.each do |vehicle_journey_at_stop|
        self.new( vehicle_journey_at_stop, directory, index, id).tap do |specific_exporter|
          specific_exporter.save
          id += 1
        end
      end
    end
    #vehicle_journey_at_stops.each do |vehicle_journey_at_stop|
    #  self.new( vehicle_journey_at_stop, directory).tap do |specific_exporter|
    #    specific_exporter.save
    #  end
    #end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_AT_STOP_COUNT", :arguments => {"0" => vehicle_journey_at_stops_count})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("HORAIRE\u000D\u000A") if f.size == 0
      f.write(render)
    end if vehicle_journey_at_stop.present?
  end
end

