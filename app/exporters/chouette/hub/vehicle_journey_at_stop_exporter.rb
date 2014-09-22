class Chouette::Hub::VehicleJourneyAtStopExporter
  include ERB::Util
  attr_accessor :vehicle_journey_at_stop, :directory, :template
  
  def initialize(vehicle_journey_at_stop, directory)
    @vehicle_journey_at_stop = vehicle_journey_at_stop
    @directory = directory
    @template = File.open('app/views/api/hub/horaires.hub.erb' ) { |f| f.read }
    @stop_area_code = Chouette::StopArea.find(@vehicle_journey_at_stop.stop_point.stop_area_id).objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
    @arrival_time = @vehicle_journey_at_stop.arrival_time.sec + 60 * @vehicle_journey_at_stop.arrival_time.min + 60 * 60 * @vehicle_journey_at_stop.arrival_time.hour
    @arrival_type = "A"
    @departure_time = @vehicle_journey_at_stop.departure_time.sec + 60 *  @vehicle_journey_at_stop.departure_time.min + 60 * 60 *  @vehicle_journey_at_stop.departure_time.hour
    @departure_type = "D"
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/HORAIRE.TXT"
  end
  
  def self.save( vehicle_journey_at_stops, directory, hub_export)
    vehicle_journey_at_stops.each do |vehicle_journey_at_stop|
      self.new( vehicle_journey_at_stop, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_AT_STOP_COUNT", :arguments => {"0" => vehicle_journey_at_stops.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("HORAIRE\n") if f.size == 0
      f.write(render)
    end if vehicle_journey_at_stop.present?
  end
end

