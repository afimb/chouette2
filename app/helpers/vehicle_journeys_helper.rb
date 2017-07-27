module VehicleJourneysHelper
  
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
  
  def vehicle_departure(vehicle, departure_time=nil)
    unless departure_time
      first_vjas = vehicle.vehicle_journey_at_stops.first
      return '' unless first_vjas.departure_time
      departure_time = first_vjas.departure_time
    end
    l(departure_time, :format => :hour).gsub( /  /, ' ')
  end

  def vehicle_title(vehicle, journey_frequency=nil)
    return t("vehicle_journeys.vehicle_journey#{'_frequency' if vehicle.frequency?}.title_stopless", :name => vehicle_name( vehicle)) if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    if vehicle.frequency? && journey_frequency
      t("vehicle_journeys.vehicle_journey_frequency.title_frequency",
        :interval => l(journey_frequency.scheduled_headway_interval, format: :hour),
        :stop => stop_name(first_vjas),
        :time_first => vehicle_departure(nil, journey_frequency.first_departure_time),
        :time_last => vehicle_departure(nil, journey_frequency.last_departure_time))
    else
      t("vehicle_journeys.vehicle_journey#{'_frequency' if vehicle.frequency?}.title",
            :stop => stop_name(first_vjas),
            :time => vehicle_departure(vehicle, (journey_frequency ? journey_frequency.first_departure_time : nil )))
    end
  end
  
  def edit_vehicle_title( vehicle)
    return t('vehicle_journeys.edit.title_stopless', :name => vehicle_name( vehicle)) if vehicle.vehicle_journey_at_stops.empty?
    first_vjas = vehicle.vehicle_journey_at_stops.first
    t('vehicle_journeys.edit.title', 
          :name => vehicle_name( vehicle),
          :stop => stop_name(first_vjas),
          :time => vehicle_departure(vehicle))
  end

  def exist_vehicle_journeys?(route)
    route.vehicle_journeys.count > 0
  end

  def special_vehicle_journey_icon(field, vehicle_journey)
    fa_class = { mobility_restricted_suitability: 'fa-wheelchair', flexible_service: 'fa-phone' }.map{ |k, v| v if k == field }.compact

    if vehicle_journey.send(field).to_s.present?
      fa_class << 'fa-line-through' unless vehicle_journey.send(field)
    elsif vehicle_journey.route.line.send(field).to_s.present?
      fa_class << 'fa-line-through' unless vehicle_journey.route.line.send(field)
    else
      return
    end
    font_awesome_classic_tag(fa_class.join(' '))
  end
end

