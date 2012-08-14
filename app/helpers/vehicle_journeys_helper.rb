module VehicleJourneysHelper
  def journey_name( journey_pattern)
    if !journey_pattern.published_name.blank?
      journey_pattern.published_name.first(8)
    elsif !journey_pattern.name.blank?
      journey_pattern.name.first(8)
    else
      journey_pattern.id
    end
  end
  def vehicle_name( vehicle)
    if !vehicle.published_journey_name.blank?
      vehicle.published_journey_name.first(8)
    elsif !vehicle.published_journey_identifier.blank?
      vehicle.published_journey_identifier.first(8)
    elsif !vehicle.number.blank?
      vehicle.number
    else
      vehicle.id
    end
  end
  def missing_time_check( is_present)
    return "missing" if (is_present && is_present.departure_time.nil?)
  end
  def vehicle_departure(vehicle)
    first_vjas = vehicle.vehicle_journey_at_stops.first
    return "" unless first_vjas.departure_time
    l(first_vjas.departure_time, :format => :hour).gsub( /  /, ' ') 
  end
  def vehicle_title( vehicle)
    return t('vehicle_journeys.vehicle_journey.title_stopless', :name => vehicle_name( vehicle)) if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    t('vehicle_journeys.vehicle_journey.title', 
          :name => vehicle_name( vehicle),
          :stop => first_vjas.stop_point.stop_area.name,
          :time => vehicle_departure(vehicle))
  end
  def edit_vehicle_title( vehicle)
    return t('vehicle_journeys.edit.title_stopless', :name => vehicle_name( vehicle)) if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    t('vehicle_journeys.edit.title', 
          :name => vehicle_name( vehicle),
          :stop => first_vjas.stop_point.stop_area.name,
          :time => vehicle_departure(vehicle))
  end
end

