class CreateChouetteAccessLink < ActiveRecord::Migration
  def up
    create_table :access_links, :force => true do |t|
      t.integer  "access_point_id", :limit => 8
      t.integer  "stop_area_id",    :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
      t.decimal  "link_distance", :precision => 19, :scale => 2
      t.boolean  "lift_availability"
      t.boolean  "mobility_restricted_suitability"
      t.boolean  "stairs_availability"
      t.time     "default_duration"
      t.time     "frequent_traveller_duration"
      t.time     "occasional_traveller_duration"
      t.time     "mobility_restricted_traveller_duration"

      t.string   "link_type"
      t.integer  "int_user_needs"
      t.string   "link_orientation"
    end
   add_index "access_links", ["objectid"], :name => "access_links_objectid_key", :unique => true
  end

  def down
    drop_table :access_links
  end
end
