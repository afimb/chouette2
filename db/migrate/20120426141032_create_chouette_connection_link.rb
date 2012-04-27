class CreateChouetteConnectionLink < ActiveRecord::Migration
  def up
  create_table "connectionlink", :force => true do |t|
    t.integer  "departureid",    :limit => 8
    t.integer  "arrivalid",      :limit => 8
    t.string   "objectid",       :null => false
    t.integer  "objectversion"
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "name"
    t.string   "comment"
    t.decimal  "linkdistance",  :precision => 19, :scale => 2
    t.string   "linktype"
    t.time     "defaultduration"
    t.time     "frequenttravellerduration"
    t.time     "occasionaltravellerduration"
    t.time     "mobilityrestrictedtravellerduration"
    t.boolean  "mobilityrestrictedsuitability"
    t.boolean  "stairsavailability"
    t.boolean  "liftavailability"
    t.integer  "intuserneeds"
  end
   add_index "connectionlink", ["objectid"], :name => "connectionlink_objectid_key", :unique => true
  end

  def down
  end
end
