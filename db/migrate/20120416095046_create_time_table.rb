class CreateTimeTable < ActiveRecord::Migration
  def up
  create_table "timetable", :force => true do |t|
    t.string   "objectid",      :null => false
    t.integer  "objectversion", :default => 1
    t.datetime "creationtime"
    t.string   "creatorid"
    t.string   "version"
    t.string   "comment"
    t.integer  "intdaytypes", :default => 0
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
  end

  def down
    drop_table "timetable_period"
    drop_table "timetable_date"
    drop_table "timetable"
  end
end
