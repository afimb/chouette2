class ConvertVehicleJourneyAtStopToNeptuneIdentifiedObject < ActiveRecord::Migration
  def change
    add_column :vehicle_journey_at_stops, :objectid, :string
    add_column :vehicle_journey_at_stops, :object_version, :integer
    add_column :vehicle_journey_at_stops, :creator_id, :string
    add_column :vehicle_journey_at_stops, :creation_time, :datetime
    execute <<-SQL
      select prefix into temporary prefix_table_vjas from public.referentials where slug = current_schema();
      update vehicle_journey_at_stops set object_version = 1, objectid = concat((select prefix from prefix_table_vjas limit 1),':TimetabledPassingTime:',id);
      drop table prefix_table_vjas;
    SQL
    change_column :footnotes, :objectid, :string, null: false
    add_index "vehicle_journey_at_stops", ["objectid"], :name => "vehicle_journey_at_stops_objectid_key", :unique => true
  end
end
