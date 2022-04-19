class SetSequenceIncrementForHibernatePooledOptimizer < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       ALTER SEQUENCE brandings_id_seq increment by 100;
       ALTER SEQUENCE facilities_id_seq increment by 100;
       ALTER SEQUENCE pt_links_id_seq increment by 100;
       ALTER SEQUENCE blocks_id_seq increment by 100;
       ALTER SEQUENCE booking_arrangements_id_seq increment by 100;
       ALTER SEQUENCE codespaces_id_seq increment by 100;
       ALTER SEQUENCE companies_id_seq increment by 100;
       ALTER SEQUENCE contact_structures_id_seq increment by 100;
       ALTER SEQUENCE dated_service_journeys_id_seq increment by 100;
       ALTER SEQUENCE dead_runs_id_seq increment by 100;
       ALTER SEQUENCE dead_run_at_stops_id_seq increment by 100;
       ALTER SEQUENCE destination_displays_id_seq increment by 100;
       ALTER SEQUENCE flexible_service_properties_id_seq increment by 100;
       ALTER SEQUENCE footnote_alternative_texts_id_seq increment by 100;
       ALTER SEQUENCE footnotes_id_seq increment by 100;
       ALTER SEQUENCE group_of_lines_id_seq increment by 100;
       ALTER SEQUENCE interchanges_id_seq increment by 100;
       ALTER SEQUENCE journey_frequencies_id_seq increment by 100;
       ALTER SEQUENCE journey_patterns_id_seq increment by 100;
       ALTER SEQUENCE lines_id_seq increment by 100;
       ALTER SEQUENCE networks_id_seq increment by 100;
       ALTER SEQUENCE routes_id_seq increment by 100;
       ALTER SEQUENCE route_points_id_seq increment by 100;
       ALTER SEQUENCE route_sections_id_seq increment by 100;
       ALTER SEQUENCE scheduled_stop_points_id_seq increment by 100;
       ALTER SEQUENCE stop_points_id_seq increment by 100;
       ALTER SEQUENCE timebands_id_seq increment by 100;
       ALTER SEQUENCE time_tables_id_seq increment by 100;
       ALTER SEQUENCE vehicle_journeys_id_seq increment by 100;
       ALTER SEQUENCE vehicle_journey_at_stops_id_seq increment by 100;

    SQL
  end

  def down
    execute <<-SQL
       ALTER SEQUENCE brandings_id_seq increment by 1;
       ALTER SEQUENCE facilities_id_seq increment by 1;
       ALTER SEQUENCE pt_links_id_seq increment by 1;
       ALTER SEQUENCE blocks_id_seq increment by 1;
       ALTER SEQUENCE booking_arrangements_id_seq increment by 1;
       ALTER SEQUENCE codespaces_id_seq increment by 1;
       ALTER SEQUENCE companies_id_seq increment by 1;
       ALTER SEQUENCE contact_structures_id_seq increment by 1;
       ALTER SEQUENCE dated_service_journeys_id_seq increment by 1;
       ALTER SEQUENCE dead_runs_id_seq increment by 1;
       ALTER SEQUENCE dead_run_at_stops_id_seq increment by 1;
       ALTER SEQUENCE destination_displays_id_seq increment by 1;
       ALTER SEQUENCE flexible_service_properties_id_seq increment by 1;
       ALTER SEQUENCE footnote_alternative_texts_id_seq increment by 1;
       ALTER SEQUENCE footnotes_id_seq increment by 1;
       ALTER SEQUENCE group_of_lines_id_seq increment by 1;
       ALTER SEQUENCE interchanges_id_seq increment by 1;
       ALTER SEQUENCE journey_frequencies_id_seq increment by 1;
       ALTER SEQUENCE journey_patterns_id_seq increment by 1;
       ALTER SEQUENCE lines_id_seq increment by 1;
       ALTER SEQUENCE networks_id_seq increment by 1;
       ALTER SEQUENCE routes_id_seq increment by 1;
       ALTER SEQUENCE route_points_id_seq increment by 1;
       ALTER SEQUENCE route_sections_id_seq increment by 1;
       ALTER SEQUENCE scheduled_stop_points_id_seq increment by 1;
       ALTER SEQUENCE stop_points_id_seq increment by 1;
       ALTER SEQUENCE timebands_id_seq increment by 1;
       ALTER SEQUENCE time_tables_id_seq increment by 1;
       ALTER SEQUENCE vehicle_journeys_id_seq increment by 1;
       ALTER SEQUENCE vehicle_journey_at_stops_id_seq increment by 1;
    SQL
  end
end
