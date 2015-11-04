class VehicleJourneyFrequenciesController < VehicleJourneysController

  defaults resource_class: Chouette::VehicleJourneyFrequency

  private

  def vehicle_journey_frequency_params
    params.require(:vehicle_journey_frequency).permit( { footnote_ids: [] } , :journey_pattern_id, :number, :published_journey_name,
                                             :published_journey_identifier, :comment, :transport_mode_name,
                                             :mobility_restricted_suitability, :flexible_service, :status_value,
                                             :facility, :vehicle_type_identifier, :objectid, :time_table_tokens,
                                             { date: [ :hour, :minute ] }, :button, :referential_id, :line_id,
                                             :route_id, :id, { vehicle_journey_at_stops_attributes: [ :arrival_time,
                                                                                                      :id, :_destroy,
                                                                                                      :stop_point_id,
                                                                                                      :departure_time] },
                                             { journey_frequencies_attributes: [ :id, :_destroy, :scheduled_headway_interval, :first_departure_time,
                                                                                 :last_departure_time, :exact_time, :timeband_id ] } )
    end
end
