class CreateChouetteFacility < ActiveRecord::Migration[4.2]
  def up
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
  end

  def down
    drop_table :facilities
  end
end
