class AddForeignKeysToFootnotes < ActiveRecord::Migration
  def change
    execute <<-SQL
      alter table footnotes_vehicle_journey_at_stops ADD constraint footnotes_vehicle_journey_at_stops_vjas_fkey FOREIGN KEY (vehicle_journey_at_stop_id) REFERENCES vehicle_journey_at_stops ON DELETE CASCADE not valid;
      alter table footnotes_vehicle_journey_at_stops ADD constraint footnotes_vehicle_journey_at_stops_footnotes_fkey FOREIGN KEY (footnote_id) REFERENCES footnotes ON DELETE CASCADE not valid;
      delete from footnotes_vehicle_journey_at_stops where not exists (select 1 from vehicle_journey_at_stops vjas where vjas.id = footnotes_vehicle_journey_at_stops.vehicle_journey_at_stop_id);
      delete from footnotes_vehicle_journey_at_stops where not exists (select 1 from footnotes f where f.id = footnotes_vehicle_journey_at_stops.footnote_id);
      ALTER TABLE footnotes_vehicle_journey_at_stops VALIDATE CONSTRAINT footnotes_vehicle_journey_at_stops_vjas_fkey;
      ALTER TABLE footnotes_vehicle_journey_at_stops VALIDATE CONSTRAINT footnotes_vehicle_journey_at_stops_footnotes_fkey;
    SQL

    execute <<-SQL
      alter table footnotes_lines ADD constraint footnotes_lines_lines_fkey FOREIGN KEY (line_id) REFERENCES lines ON DELETE CASCADE not valid;
      alter table footnotes_lines ADD constraint footnotes_lines_footnotes_fkey FOREIGN KEY (footnote_id) REFERENCES footnotes ON DELETE CASCADE not valid;
      delete from footnotes_lines where not exists (select 1 from lines vjas where vjas.id = footnotes_lines.line_id);
      delete from footnotes_lines where not exists (select 1 from footnotes f where f.id = footnotes_lines.footnote_id);
      ALTER TABLE footnotes_lines VALIDATE CONSTRAINT footnotes_lines_lines_fkey;
      ALTER TABLE footnotes_lines VALIDATE CONSTRAINT footnotes_lines_footnotes_fkey;
    SQL

    execute <<-SQL
      alter table footnotes_journey_patterns ADD constraint footnotes_journey_patterns_journey_patterns_fkey FOREIGN KEY (journey_pattern_id) REFERENCES journey_patterns ON DELETE CASCADE not valid;
      alter table footnotes_journey_patterns ADD constraint footnotes_journey_patterns_footnotes_fkey FOREIGN KEY (footnote_id) REFERENCES footnotes ON DELETE CASCADE not valid;
      delete from footnotes_journey_patterns where not exists (select 1 from journey_patterns vjas where vjas.id = footnotes_journey_patterns.journey_pattern_id);
      delete from footnotes_journey_patterns where not exists (select 1 from footnotes f where f.id = footnotes_journey_patterns.footnote_id);
      ALTER TABLE footnotes_journey_patterns VALIDATE CONSTRAINT footnotes_journey_patterns_journey_patterns_fkey;
      ALTER TABLE footnotes_journey_patterns VALIDATE CONSTRAINT footnotes_journey_patterns_footnotes_fkey;
    SQL

    execute <<-SQL
      alter table footnotes_vehicle_journeys ADD constraint footnotes_vehicle_journeys_vehicle_journeys_fkey FOREIGN KEY (vehicle_journey_id) REFERENCES vehicle_journeys ON DELETE CASCADE not valid;
      alter table footnotes_vehicle_journeys ADD constraint footnotes_vehicle_journeys_footnotes_fkey FOREIGN KEY (footnote_id) REFERENCES footnotes ON DELETE CASCADE not valid;
      delete from footnotes_vehicle_journeys where not exists (select 1 from vehicle_journeys vjas where vjas.id = footnotes_vehicle_journeys.vehicle_journey_id);
      delete from footnotes_vehicle_journeys where not exists (select 1 from footnotes f where f.id = footnotes_vehicle_journeys.footnote_id);
      ALTER TABLE footnotes_vehicle_journeys VALIDATE CONSTRAINT footnotes_vehicle_journeys_vehicle_journeys_fkey;
      ALTER TABLE footnotes_vehicle_journeys VALIDATE CONSTRAINT footnotes_vehicle_journeys_footnotes_fkey;
    SQL

    execute <<-SQL
      alter table footnotes_stop_points ADD constraint footnotes_stop_points_stop_points_fkey FOREIGN KEY (stop_point_id) REFERENCES stop_points ON DELETE CASCADE not valid;
      alter table footnotes_stop_points ADD constraint footnotes_stop_points_footnotes_fkey FOREIGN KEY (footnote_id) REFERENCES footnotes ON DELETE CASCADE not valid;
      delete from footnotes_stop_points where not exists (select 1 from stop_points vjas where vjas.id = footnotes_stop_points.stop_point_id);
      delete from footnotes_stop_points where not exists (select 1 from footnotes f where f.id = footnotes_stop_points.footnote_id);
      ALTER TABLE footnotes_stop_points VALIDATE CONSTRAINT footnotes_stop_points_stop_points_fkey;
      ALTER TABLE footnotes_stop_points VALIDATE CONSTRAINT footnotes_stop_points_footnotes_fkey;
    SQL
  end
end
