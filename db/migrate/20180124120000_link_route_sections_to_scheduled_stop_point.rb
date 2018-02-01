class LinkRouteSectionsToScheduledStopPoint < ActiveRecord::Migration

  def change
    add_column :route_sections, :from_scheduled_stop_point_id, :integer, null: true
    remove_column :route_sections, :arrival_stop_area_objectid_key

    add_column :route_sections, :to_scheduled_stop_point_id, :integer, null: true
    remove_column :route_sections, :departure_stop_area_objectid_key
    end
end
