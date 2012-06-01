class CreateChouetteTimeSlot < ActiveRecord::Migration
  def up
    create_table :time_slots, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.datetime "beginning_slot_time"
      t.datetime "end_slot_time"
      t.datetime "first_departure_time_in_slot"
      t.datetime "last_departure_time_in_slot"
    end
   add_index "time_slots", ["objectid"], :name => "time_slots_objectid_key", :unique => true
  end

  def down
   remove_index "time_slots", :name => "time_slot_objectid_key"
   drop_table :time_slots
  end
end
