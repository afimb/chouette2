class Chouette::Hub::VehicleJourneyOperationExporter
  include ERB::Util
  attr_accessor :vehicle_journey, :directory, :template
  
  def initialize(vehicle_journey, directory, index)
    @vehicle_journey = vehicle_journey
    @number = index
    @directory = directory
    @template = File.open('app/views/api/hub/courses_operations.hub.erb' ) { |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/COURSE_OPERATION.TXT"
  end
  
  def self.save( vehicle_journeys, directory, hub_export)
    vehicle_journeys.each_index do |index|
      self.new( vehicle_journeys[index], directory, index).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    #vehicle_journeys.each do |vehicle_journey|
    #  self.new( vehicle_journey, directory).tap do |specific_exporter|
    #    specific_exporter.save
    #  end
    #end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_COUNT", :arguments => {"0" => vehicle_journeys.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("COURSE_OPERATION\n") if f.size == 0
      f.write(render)
    end if vehicle_journey.present?
  end
end

