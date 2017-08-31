class CreateScheduledStopPoint < ActiveRecord::Migration
  def change
    create_table :scheduled_stop_points do |t|
      t.string   "objectid",                  null: false
      t.string   "stop_area_objectid_key"
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.string   "name"
      t.string   "for_boarding"
      t.string   "for_alighting"
    end
    add_column :stop_points, :scheduled_stop_point_id, :integer, null: true
    add_foreign_key :stop_points, :scheduled_stop_points

    execute <<-SQL
      insert into scheduled_stop_points (objectid, stop_area_objectid_key,object_version,creation_time,creator_id,name, for_boarding, for_alighting) select REPLACE(sp.objectid,'StopPoint','ScheduledStopPoint'),sp.stop_area_objectid_key,sp.object_version,sp.creation_time,sp.creator_id, sa.name, sp.for_boarding, sp.for_alighting from
         stop_points sp left join public.stop_areas sa on  sp.stop_area_objectid_key = sa.objectid;
      update stop_points sp set scheduled_stop_point_id = (select id from scheduled_stop_points where REPLACE(sp.objectid,'StopPoint','ScheduledStopPoint') = scheduled_stop_points.objectid);

      update  interchanges i set from_point = (select ssp.objectid from scheduled_stop_points ssp  inner join stop_points sp on sp.scheduled_stop_point_id=ssp.id where sp.objectid=i.from_point),
to_point = (select ssp.objectid from  scheduled_stop_points ssp  inner join  stop_points sp on sp.scheduled_stop_point_id=ssp.id where sp.objectid=i.to_point);

    SQL
    change_column :stop_points, :scheduled_stop_point_id, :integer, null: false
    remove_column :stop_points, :stop_area_objectid_key, :for_boarding, :for_alighting
  end
end
