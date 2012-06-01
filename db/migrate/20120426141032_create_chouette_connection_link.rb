class CreateChouetteConnectionLink < ActiveRecord::Migration
  def up
  create_table "connection_links", :force => true do |t|
    t.integer  "departure_id",    :limit => 8
    t.integer  "arrival_id",      :limit => 8
    t.string   "objectid",       :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",  :precision => 19, :scale => 2
    t.string   "link_type"
    t.time     "default_duration"
    t.time     "frequent_traveller_duration"
    t.time     "occasional_traveller_duration"
    t.time     "mobility_restricted_traveller_duration"
    t.boolean  "mobility_restricted_suitability"
    t.boolean  "stairs_availability"
    t.boolean  "lift_availability"
    t.integer  "int_user_needs"
  end
   add_index "connection_links", ["objectid"], :name => "connection_links_objectid_key", :unique => true
  end

  def down
  end
end
