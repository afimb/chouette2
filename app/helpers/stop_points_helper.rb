module StopPointsHelper

  def stop_name(point)
    case point
      when Chouette::StopArea
        point.name
      when Chouette::StopPoint
        point.name
      when Chouette::VehicleJourneyAtStop
        point.stop_point.name
      when nil
        'Unknown'
      else
        point.name
    end
  end

end
