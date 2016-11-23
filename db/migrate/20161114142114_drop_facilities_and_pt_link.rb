class DropFacilitiesAndPtLink < ActiveRecord::Migration
  def up
    drop_table :facilities
    drop_table :facilities_features
    drop_table :pt_links
  end

  def down
    create_table :facilities, :force => true do |t|
      t.integer  "stop_area_id",      :limit => 8
      t.integer  "line_id",          :limit => 8
      t.integer  "connection_link_id",:limit => 8
      t.integer  "stop_point_id",     :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
      t.string   "description"
      t.boolean  "free_access"
      t.decimal  "longitude",      :precision => 19, :scale => 16
      t.decimal  "latitude",       :precision => 19, :scale => 16
      t.string   "long_lat_type"
      t.decimal  "x",              :precision => 19, :scale => 2
      t.decimal  "y",              :precision => 19, :scale => 2
      t.string   "projection_type"
      t.string   "country_code"
      t.string   "street_name"
      t.string   "contained_in"
    end
    add_index "facilities", ["objectid"], :name => "facilities_objectid_key", :unique => true

    create_table :facilities_features, :id => false, :force => true do |t|
      t.integer  "facility_id", :limit => 8
      t.integer  "choice_code"
    end

    create_table "pt_links", :force => true do |t|
      t.integer  "start_of_link_id",    :limit => 8
      t.integer  "end_of_link_id",      :limit => 8
      t.integer  "route_id",      :limit => 8
      t.string   "objectid",       :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.string   "comment"
      t.decimal  "link_distance",  :precision => 19, :scale => 2
    end
    add_index "pt_links", ["objectid"], :name => "pt_links_objectid_key", :unique => true
  end
end
