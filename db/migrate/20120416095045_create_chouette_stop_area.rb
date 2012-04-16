class CreateChouetteStopArea < ActiveRecord::Migration
  def up
    create_table "stoparea", :force => true do |t|
      t.integer  "parentid",           :limit => 8
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.string   "name"
      t.string   "comment"
      t.string   "areatype"
      t.string   "registrationnumber"
      t.string   "nearesttopicname"
      t.integer  "farecode"
      t.decimal  "longitude",                       :precision => 19, :scale => 16
      t.decimal  "latitude",                        :precision => 19, :scale => 16
      t.string   "longlattype"
      t.decimal  "x",                               :precision => 19, :scale => 2
      t.decimal  "y",                               :precision => 19, :scale => 2
      t.string   "projectiontype"
      t.string   "countrycode"
      t.string   "streetname"
      t.integer  "modes",                                                           :default => 0
    end

    add_index "stoparea", ["objectid"], :name => "stoparea_objectid_key", :unique => true
    add_index "stoparea", ["parentid"], :name => "index_stoparea_on_parentid"

  end

  def down
    drop_table "stoparea"
  end
end
