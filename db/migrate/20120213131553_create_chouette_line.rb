class CreateChouetteLine < ActiveRecord::Migration
  def up
    create_table "line", :force => true do |t|
      t.integer  "ptnetworkid",                :limit => 8
      t.integer  "companyid",                  :limit => 8
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.string   "name"
      t.string   "number"
      t.string   "publishedname"
      t.string   "transportmodename"
      t.string   "registrationnumber"
      t.string   "comment"
      t.boolean  "mobilityrestrictedsuitable"
      t.integer  "userneeds",                  :limit => 8
    end

    add_index "line", ["objectid"], :name => "line_objectid_key", :unique => true
    add_index "line", ["registrationnumber"], :name => "line_registrationnumber_key", :unique => true
  end

  def down    
  end
end
