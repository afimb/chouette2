class Chouette::Hub::VehicleJourneyExporter
  include ERB::Util
  attr_accessor :vehicle_journey, :directory, :template
  
  def initialize(vehicle_journey, directory)
    @vehicle_journey = vehicle_journey
    @directory = directory
    @template = File.open('app/views/api/hub/course/show.hub.erb' ) { |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/COURSE.TXT"
  end
  
  def self.save( vehicle_journeys, directory, hub_export)
    vehicle_journeys.each do |vehicle_journey|
      #Chouette::Hub::VehicleJourneyAtStopExporter.save(vehicle_journey.vehicle_journey_at_stops, directory, hub_export)
      self.new( vehicle_journey, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_COUNT", :arguments => {"0" => vehicle_journeys.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("COURSE\n") if f.size == 0
      f.write(render)
    end if vehicle_journey.present?
  end
end

