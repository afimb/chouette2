class CreateTimeTable < ActiveRecord::Migration[4.2]
  def up
  create_table "time_tables", :force => true do |t|
    t.string   "objectid",      :null => false
    t.integer  "object_version", :default => 1
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "version"
    t.string   "comment"
    t.integer  "int_day_types", :default => 0
  end

  add_index "time_tables", ["objectid"], :name => "time_tables_objectid_key", :unique => true

  create_table "time_table_dates", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "date"
    t.integer "position",                 :null => false
  end

  add_index "time_table_dates", ["time_table_id"], :name => "index_time_table_dates_on_time_table_id"

  create_table "time_table_periods", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "period_start"
    t.date    "period_end"
    t.integer "position",                 :null => false
  end

  add_index "time_table_periods", ["time_table_id"], :name => "index_time_table_periods_on_time_table_id"
  end

  def down
    drop_table "time_table_periods"
    drop_table "time_table_dates"
    drop_table "time_tables"
  end
end
