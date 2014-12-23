class VehicleJourneyPresenter

  def initialize(vehicle_journey)
    @vehicle_journey = vehicle_journey
  end

  def time_tables_shortest_info
    return I18n.t('time_tables.time_table.empty') if @vehicle_journey.bounding_dates.empty?
    "#{I18n.l(@vehicle_journey.bounding_dates.min)} #{I18n.l(@vehicle_journey.bounding_dates.max)}"
  end
end
