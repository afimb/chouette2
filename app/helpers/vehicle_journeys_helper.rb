module VehicleJourneysHelper
  def vehicle_title( vehicle)
    return t('vehicle_journeys.vehicle_journey.title_stopless') if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    t('vehicle_journeys.vehicle_journey.title', 
          :name => vehicle.published_journey_name,
          :stop => first_vjas.stop_point.stop_area.name,
          :time => l(first_vjas.departure_time, :format => :hour)).gsub( /  /, ' ')
  end
  def edit_vehicle_title( vehicle)
    return t('vehicle_journeys.edit.title_stopless') if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    t('vehicle_journeys.edit.title', 
          :name => vehicle.published_journey_name,
          :stop => first_vjas.stop_point.stop_area.name,
          :time => l(first_vjas.departure_time, :format => :hour)).gsub( /  /, ' ')
  end
end

