class CreateChouetteTimeSlot < ActiveRecord::Migration[4.2]
  def up
    create_table :time_slots, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.time "beginning_slot_time"
      t.time "end_slot_time"
      t.time "first_departure_time_in_slot"
      t.time "last_departure_time_in_slot"
    end
   add_index "time_slots", ["objectid"], :name => "time_slots_objectid_key", :unique => true
  end

  def down
   remove_index "time_slots", :name => "time_slots_objectid_key"
   drop_table :time_slots
  end
end
