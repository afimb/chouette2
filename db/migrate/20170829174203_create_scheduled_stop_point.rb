class CreateScheduledStopPoint < ActiveRecord::Migration
  def change
    create_table :scheduled_stop_points do |t|
      t.string   "objectid",                  null: false
      t.string   "stop_area_objectid_key"
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.string   "name"
    end
    add_column :stop_points, :scheduled_stop_point_id, :integer, null: false
    add_foreign_key :stop_points, :scheduled_stop_points
    execute <<-SQL
      insert into scheduled_stop_points (objectid, stop_area_objectid_key,object_version,creation_time,creator_id,name) select REPLACE(sp.objectid,'StopPoint','ScheduledStopPoint'),sp.stop_area_objectid_key,sp.object_version,sp.creation_time,sp.creator_id, sa.name from
         stop_points sp left join stop_areas sa on  sp.stop_area_objectid_key = sa.objectid
      ;
      update stop_points sp set scheduled_stop_point_id = (select id from scheduled_stop_points where REPLACE(sp.objectid,'StopPoint','ScheduledStopPoint') = scheduled_stop_points.objectid);
    SQL

    remove_column :stop_points, :stop_area_objectid_key

  end
end
