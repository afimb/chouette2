class VehicleTranslation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :vehicle_journey_id, :count, :duration
  attr_accessor :first_stop_time, :departure_or_arrival

  validates_presence_of :count, :duration, :first_stop_time, :departure_or_arrival
  validates_inclusion_of :departure_or_arrival, :in =>  %w( departure arrival)
  validates_numericality_of :count, greater_than: 0
  validates_numericality_of :duration, greater_than: 0
  validate :firts_stop_time_format
  validate :vehicle_has_stop_times

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def firts_stop_time_format
    if first_stop_time.blank?
      errors.add :first_stop_time, I18n.t('activemodel.errors.models.vehicle_translation.unreadable_time') unless self.class.time_format_text?( self.first_stop_time)
    end
  end

  def self.time_format_text?( text)
    begin
      Time.parse text
    rescue
      false
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

  def move_time_in_current_time_zone( time )
    Time.parse( "#{time.hour}:#{time.min}")
  end
  def evaluate_delta( actual_time)
    Time.parse( first_stop_time) - move_time_in_current_time_zone( actual_time)
  end
  def vjas_time_attribute
    "#{departure_or_arrival}_time"
  end
  def first_vjas_time
    vehicle_journey.vehicle_journey_at_stops.first.send( vjas_time_attribute)
  end
  def first_delta
    evaluate_delta( first_vjas_time)
  end

  def translate
    copied_attributes = vehicle_journey.attributes
    copied_attributes.delete( "id")
    copied_attributes.delete( "objectid")

    # time shift for current duplicated vehicle
    delta = first_delta

    vehicle_journey.transaction do
      1.upto( count.to_i) do |index|
        translated = Chouette::VehicleJourney.create( copied_attributes)
        translated.time_tables = vehicle_journey.time_tables

        vehicle_journey.vehicle_journey_at_stops.each do |vjas|
          vjas_attributes = vjas.attributes.merge( "vehicle_journey_id" => translated.id)
          vjas_attributes.delete( "id" )
          vjas_attributes.merge! "departure_time" => ( vjas_attributes[ "departure_time"] + delta),
                                 "arrival_time" => ( vjas_attributes[ "arrival_time"] + delta)

          Chouette::VehicleJourneyAtStop.create( vjas_attributes)
        end
        delta += duration.to_i.minutes
      end
    end
  end

  def first_stop_name
    @first_stop_name ||= stop_name(vehicle_journey.vehicle_journey_at_stops.first)
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
