module VehicleJourneyFrequenciesHelper
  def journey_frequency_percent(journey_frequency)
    base = 100.0 / 2359.0
    left = base * journey_frequency.first_departure_time.strftime("%H%M").to_i
    right = base * journey_frequency.last_departure_time.strftime("%H%M").to_i
    width = (right < left ? 100 - left : right - left)
    [left.round(2), width.round(2)]
  end
end
