module JourneyPatternsHelper

  def journey_name(journey_pattern, field_length = 30)
    unless journey_pattern.name.blank?
      return truncate(journey_pattern.name, :length => field_length)
    end

    unless journey_pattern.stop_points.empty?
      return truncate( t('journey_patterns.journey_pattern.from_to',
        :departure => journey_pattern.stop_points.first.stop_area.name,
        :arrival => journey_pattern.stop_points.last.stop_area.name), :length => field_length)
    end

    journey_pattern.id.to_s
  end

  def stop_point_ids_label(journey_pattern)
    return journey_pattern.human_attribute_name(:stop_point_ids) if journey_pattern.vehicle_journeys.empty?

    "#{journey_pattern.human_attribute_name(:stop_point_ids)}. #{t('journey_patterns.form.warning', :count => journey_pattern.vehicle_journeys.count)}"
  end
  def icon_code(stop_point, journey)
    code = "stop_area"
    if stop_point.stop_area.id == journey.route.stop_areas.first.id
      code << "_green"
    elsif stop_point.stop_area.id == journey.route.stop_areas.last.id
      code << "_red"
    else
      code << "_black"
    end
    unless journey.stop_points.include?( stop_point)
      code << "_unselected"
    end
    code
  end
end
