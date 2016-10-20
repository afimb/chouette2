class AddDayOffsetToVehicleJourneyAtStops < ActiveRecord::Migration
  def up
    add_column :vehicle_journey_at_stops, :arrival_day_offset, :integer, null: false, default: 0
    add_column :vehicle_journey_at_stops, :departure_day_offset, :integer, null: false, default: 0
    
  end
    
  def data
    execute %q{
      CREATE OR REPLACE FUNCTION migrate_day_offset()
        RETURNS VOID AS $$
      DECLARE
        rec_vjs RECORD;
        rec_vjas RECORD;
        previous_vjas RECORD;
        is_first_stop INTEGER := 0;
        arrival_offset INTEGER;
        departure_offset INTEGER;

      BEGIN
        FOR rec_vjs IN SELECT id FROM vehicle_journeys LOOP
          departure_offset := 0;
          arrival_offset := 0;
          is_first_stop := 0;
          FOR rec_vjas IN SELECT vehicle_journey_at_stops.id, vehicle_journey_at_stops.departure_time, vehicle_journey_at_stops.arrival_time FROM vehicle_journey_at_stops, stop_points
            WHERE  vehicle_journey_at_stops.vehicle_journey_id = rec_vjs.id
            AND  vehicle_journey_at_stops.stop_point_id = stop_points.id
            ORDER BY stop_points.position LOOP
            IF is_first_stop = 0 THEN
              IF rec_vjas.departure_time < rec_vjas.arrival_time THEN
                departure_offset := departure_offset + 1;
              END IF;
              is_first_stop := 1;
            ELSE
              IF rec_vjas.arrival_time < previous_vjas.arrival_time THEN
                arrival_offset := arrival_offset + 1;
              END IF;

              IF rec_vjas.departure_time < previous_vjas.departure_time THEN
                departure_offset := departure_offset + 1;
              END IF;
            END IF;
            IF departure_offset > 0 OR arrival_offset > 0 THEN
              EXECUTE 'update vehicle_journey_at_stops' ||
                ' SET arrival_day_offset = ''' || arrival_offset || '''
                , departure_day_offset = ''' || departure_offset || '''
                WHERE id =  ' || rec_vjas.id;
            END IF;
            previous_vjas := rec_vjas;
          END LOOP;
        END LOOP;
      END;
      $$LANGUAGE plpgsql;
    }
    ActiveRecord::Base.connection.execute("select * from migrate_day_offset()")
    ActiveRecord::Base.connection.execute("DROP FUNCTION IF EXISTS migrate_day_offset()")
  end
    
  def down
    remove_columns :vehicle_journey_at_stops, :arrival_day_offset, :departure_day_offset
  end
end
