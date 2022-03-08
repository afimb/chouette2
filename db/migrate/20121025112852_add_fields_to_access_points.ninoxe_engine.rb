# This migration comes from ninoxe_engine (originally 20121024072219)
class AddFieldsToAccessPoints < ActiveRecord::Migration[4.2]
  def change
    remove_column "access_points", "mobility_restricted_suitability"
    remove_column "access_points", "stairs_availability"
    add_column "access_points", "mobility_restricted_suitability", "boolean"
    add_column "access_points", "stairs_availability", "boolean"
    rename_column "access_points", "type","access_type"
    change_column "access_points", "openning_time","time"
    change_column "access_points", "closing_time","time"
    add_column "access_points", "stop_area_id", "integer", {:limit => 8}
  end
end
