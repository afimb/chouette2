class CreateChouetteStopArea < ActiveRecord::Migration
  def up
    create_table "stop_areas", :force => true do |t|
      t.integer  "parent_id",           :limit => 8
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.string   "comment"
      t.string   "area_type"
      t.string   "registration_number"
      t.string   "nearest_topic_name"
      t.integer  "fare_code"
      t.decimal  "longitude",                       :precision => 19, :scale => 16
      t.decimal  "latitude",                        :precision => 19, :scale => 16
      t.string   "long_lat_type"
      t.decimal  "x",                               :precision => 19, :scale => 2
      t.decimal  "y",                               :precision => 19, :scale => 2
      t.string   "projection_type"
      t.string   "country_code"
      t.string   "street_name"
    end

    add_index "stop_areas", ["objectid"], :name => "stop_areas_objectid_key", :unique => true
    add_index "stop_areas", ["parent_id"], :name => "index_stop_areas_on_parent_id"

  end

  def down
    drop_table "stop_areas"
  end
end
