module JourneyPatternsHelper
  def journey_name( journey_pattern)
    if journey_pattern.name.blank?
      t('journey_patterns.journey_pattern.from_to', 
        :departure => journey_pattern.stop_points.first.stop_area.name, 
        :arrival => journey_pattern.stop_points.last.stop_area.name)
    else
      truncate(journey_pattern.name, :length => 30)
    end
  end
end

