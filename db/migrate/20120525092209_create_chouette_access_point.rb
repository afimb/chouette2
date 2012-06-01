class CreateChouetteAccessPoint < ActiveRecord::Migration
  def up
    create_table :access_points, :force => true do |t|
      t.string   "objectid"
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
      t.decimal  "longitude",      :precision => 19, :scale => 16
      t.decimal  "latitude",       :precision => 19, :scale => 16
      t.string   "long_lat_type"
      t.decimal  "x",              :precision => 19, :scale => 2
      t.decimal  "y",              :precision => 19, :scale => 2
      t.string   "projection_type"
      t.string   "country_code"
      t.string   "street_name"
      t.string   "contained_in"

      t.datetime "openning_time"
      t.datetime "closing_time"
      t.string   "type"
      t.boolean  "lift_availability"
      t.datetime "mobility_restricted_suitability"
      t.datetime "stairs_availability"
    end
   add_index "access_points", ["objectid"], :name => "access_points_objectid_key", :unique => true
  end

  def down
    drop_table :access_points
  end
end
