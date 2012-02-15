# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120214101645) do

  create_table "company", :force => true do |t|
    t.string   "objectid"
    t.integer  "objectversion"
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "name"
    t.string   "shortname"
    t.string   "organizationalunit"
    t.string   "operatingdepartmentname"
    t.string   "code"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "registrationnumber"
  end

  add_index "company", ["objectid"], :name => "company_objectid_key", :unique => true
  add_index "company", ["registrationnumber"], :name => "company_registrationnumber_key", :unique => true

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

  create_table "referentials", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
