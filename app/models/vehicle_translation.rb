class VehicleTranslation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :vehicle_journey_id, :count, :duration
  attr_accessor :first_stop_arrival_time, :first_stop_departure_time

  validates_presence_of :count, :duration
  validates_numericality_of :count, greater_than: 0
  validates_numericality_of :duration, greater_than: 0
  validate :starting_time_provided
  validate :vehicle_has_stop_times

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def starting_time_provided
    if ( first_stop_arrival_time.blank? && first_stop_departure_time.blank?)
      errors.add :first_stop_arrival_time, I18n.t('activemodel.errors.models.vehicle_translation.missing_start_time')
      errors.add :first_stop_departure_time, I18n.t('activemodel.errors.models.vehicle_translation.missing_start_time')
      #errors.add( :first_stop_departure_time => "un horaire de départ ou d'arrivée au premier arrêt doit être renseigné")
    elsif first_stop_departure_time.blank?
      errors.add :first_stop_arrival_time, I18n.t('activemodel.errors.models.vehicle_translation.unreadable_time') unless Time.parse( self.first_stop_arrival_time) rescue false
    elsif first_stop_arrival_time.blank?
      errors.add :first_stop_departure_time, I18n.t('activemodel.errors.models.vehicle_translation.unreadable_time') unless Time.parse( self.first_stop_departure_time) rescue false
    end
  end

  def vehicle_has_stop_times
    if vehicle_journey.vehicle_journey_at_stops.empty?
      errors.add :vehicle_journey_id, I18n.t('activemodel.errors.models.vehicle_translation.uncompiliant_vehicle')
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

  def first_stop_name
    @first_stop_name ||= vehicle_journey.vehicle_journey_at_stops.first.stop_point.stop_area.name
  end

  def vehicle_journey
    @vehicle_journey ||= Chouette::VehicleJourney.find( vehicle_journey_id)
  end

  def self.from_vehicle( vehicle)
    VehicleTranslation.new( :vehicle_journey_id => vehicle.id,
                            :count => 0,
                            :translation => 5.minutes)
  end
end
