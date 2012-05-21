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

ActiveRecord::Schema.define(:version => 20120516172252) do

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

  create_table "connectionlink", :force => true do |t|
    t.integer  "departureid",                         :limit => 8
    t.integer  "arrivalid",                           :limit => 8
    t.string   "objectid",                                                                        :null => false
    t.integer  "objectversion"
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "name"
    t.string   "comment"
    t.decimal  "linkdistance",                                     :precision => 19, :scale => 2
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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "imports", :force => true do |t|
    t.integer  "referential_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["referential_id"], :name => "index_imports_on_referential_id"

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

  create_table "route", :force => true do |t|
    t.integer  "lineid",          :limit => 8
    t.string   "objectid"
    t.integer  "objectversion"
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "name"
    t.string   "comment"
    t.integer  "oppositerouteid", :limit => 8
    t.string   "publishedname"
    t.string   "number"
    t.string   "direction"
    t.string   "wayback"
  end

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

  create_table "stoppoint", :force => true do |t|
    t.integer  "routeid",       :limit => 8
    t.integer  "stopareaid",    :limit => 8
    t.string   "objectid"
    t.integer  "objectversion"
    t.datetime "creationtime"
    t.string   "creatorid"
    t.integer  "position"
  end

  create_table "timetable", :force => true do |t|
    t.string   "objectid",                     :null => false
    t.integer  "objectversion", :default => 1
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "version"
    t.string   "comment"
    t.integer  "intdaytypes",   :default => 0
  end

  add_index "timetable", ["objectid"], :name => "timetable_objectid_key", :unique => true

  create_table "timetable_date", :id => false, :force => true do |t|
    t.integer "timetableid", :limit => 8, :null => false
    t.date    "date"
    t.integer "position",                 :null => false
  end

  add_index "timetable_date", ["timetableid"], :name => "index_timetable_date_on_timetableid"

  create_table "timetable_period", :id => false, :force => true do |t|
    t.integer "timetableid", :limit => 8, :null => false
    t.date    "periodstart"
    t.date    "periodend"
    t.integer "position",                 :null => false
  end

  add_index "timetable_period", ["timetableid"], :name => "index_timetable_period_on_timetableid"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
