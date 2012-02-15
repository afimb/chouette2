class CreateChouettePtnetwork < ActiveRecord::Migration
  def up
    create_table "ptnetwork", :force => true do |t|
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.date     "versiondate"
      t.string   "description"
      t.string   "name"
      t.string   "registrationnumber"
      t.string   "sourcename"
      t.string   "sourceidentifier"
      t.string   "comment"
    end

    add_index "ptnetwork", ["objectid"], :name => "ptnetwork_objectid_key", :unique => true
    add_index "ptnetwork", ["registrationnumber"], :name => "ptnetwork_registrationnumber_key", :unique => true
  end

  def down
  end
end
