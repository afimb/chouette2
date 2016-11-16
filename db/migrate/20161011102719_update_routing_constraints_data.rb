class UpdateRoutingConstraintsData < ActiveRecord::Migration
  def data
    execute %q(
      CREATE OR REPLACE FUNCTION update_routing_constraints_data() RETURNS VOID AS $$
        DECLARE
          rec_stop_area_itl RECORD;
          var_stop_area_id INTEGER;
          rec_line_id RECORD;
          rec_stop_area_id RECORD;
          id_rc INTEGER;
        BEGIN
          FOR rec_stop_area_itl IN SELECT id
                                   FROM stop_areas
                                   WHERE area_type ilike 'itl' LOOP
            var_stop_area_id := rec_stop_area_itl.id;
            FOR id_rc IN INSERT INTO routing_constraints (name, objectid)
                         VALUES (var_stop_area_id, var_stop_area_id) RETURNING id LOOP
              FOR rec_line_id IN SELECT line_id
                                 FROM routing_constraints_lines_previous AS rclp 
                                 WHERE rclp.stop_area_id = var_stop_area_id LOOP
                EXECUTE 'INSERT INTO routing_constraints_lines (routing_constraint_id, line_id)
                         VALUES ('|| id_rc ||', '|| rec_line_id ||')';
              END LOOP;
              FOR rec_stop_area_id IN SELECT child_id FROM stop_areas_stop_areas AS sasa 
                                      WHERE sasa.parent_id = var_stop_area_id LOOP
                EXECUTE 'INSERT INTO routing_constraints_stop_areas (routing_constraint_id, stop_area_id)
                         VALUES ('|| id_rc ||', '|| rec_stop_area_id ||')';
              END LOOP;
            END LOOP;
          END LOOP;
        END;
      $$LANGUAGE plpgsql;
      )
      ActiveRecord::Base.connection.execute("SELECT * from update_routing_constraints_data()")
      ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS update_routing_constraints_data()")
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS routing_constraints_lines_previous")
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS stop_areas_stop_areas")
      ActiveRecord::Base.connection.execute("DELETE FROM stop_areas WHERE area_type ilike 'itl'")
  end
end
