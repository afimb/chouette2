class Chouette::Hub::VehicleJourneyOperationExporter
  include ERB::Util
  attr_accessor :vehicle_journey, :directory, :template
  
  def initialize(vehicle_journey, directory, index)
    @vehicle_journey = vehicle_journey
    @number = index
    @directory = directory
    @template = File.open('app/views/api/hub/courses_operations.hub.erb' ) { |f| f.read }
    # HUB TMode vs. Neptune TMode
    # transport_mode = "TAD_PMR" if (@vehicle_journey.flexible_service && @vehicle_journey.mobility_restricted_suitability) # SISMO profile : NO TAD_PMR MODE.
    if @vehicle_journey.flexible_service
      transport_mode = "TAD" 
    else
      case @vehicle_journey.transport_mode
      when "Interchange"
        transport_mode = ""
      when "Unknown"
        transport_mode = ""
      when "Coach"
        if @vehicle_journey.mobility_restricted_suitability
          transport_mode = "CAR_PMR"
        else
          transport_mode = "CAR"
        end
      when "Air"
        transport_mode = "AVION"
      when "Water"
        transport_mode = "BATEAU"
      when "Bus"
        if @vehicle_journey.mobility_restricted_suitability
          transport_mode = "BUS_PMR"
        else
          transport_mode = "BUS"
        end
      when "Ferry"
        transport_mode = "BATEAU"
      when "Walk"
        transport_mode = ""
      when "Metro"
        transport_mode = "METRO"
      when "Shuttle"
        transport_mode = ""
      when "RapidTransit"
        transport_mode = ""
      when "Taxi"
        transport_mode = "TAXIBUS"
      when "LocalTrain"
        transport_mode = "TRAIN"
      when "Train"
        transport_mode = "TRAIN"
      when "LongDistance_train"
        transport_mode = "TRAIN"
      when "Tram"
        transport_mode = "TRAM"
      when "Trolleybus"
        transport_mode = "TROLLEY"
      when "PrivateVehicle"
        transport_mode = ""
      when "Bicycle"
        transport_mode = "VELO"
      when "Other"
        transport_mode = ""
      else
        transport_mode = ""
      end
    end
    @transport_mode = transport_mode
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
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|VEHICLE_JOURNEY_OPERATION_COUNT", :arguments => {"0" => vehicle_journeys.size})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("COURSE_OPERATION\u000D\u000A") if f.size == 0
      f.write(render)
    end if vehicle_journey.present?
  end
end

