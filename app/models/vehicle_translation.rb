class VehicleTranslation
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
    
  attr_accessor :vehicle_journey_id, :count, :duration
  
  validates_presence_of :count, :duration

  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
    
  def persisted?  
    false  
  end 

  def translate
    vehicle = vehicle_journey
    copied_attributes = vehicle_journey.attributes
    copied_attributes.delete( "id")
    copied_attributes.delete( "objectid")

    1.upto( count.to_i) do |index|
      translated = Chouette::VehicleJourney.create( copied_attributes)
      translated.time_tables = vehicle.time_tables
      vehicle.vehicle_journey_at_stops.each do |vjas|
        vjas_attributes = vjas.attributes.merge( "vehicle_journey_id" => translated.id)
        vjas_attributes.merge! "departure_time" => ( vjas_attributes[ "departure_time"] + (index * duration.to_i.minutes) ),
          "arrival_time" => ( vjas_attributes[ "arrival_time"] + (index * duration.to_i.minutes) )

        Chouette::VehicleJourneyAtStop.create( vjas_attributes)
      end

    end
  end
  
  def vehicle_journey
    Chouette::VehicleJourney.find( vehicle_journey_id)
  end

  def self.from_vehicle( vehicle)
    VehicleTranslation.new( :vehicle_journey_id => vehicle.id,
                            :count => 0,
                            :translation => 5.minutes)
  end
end
