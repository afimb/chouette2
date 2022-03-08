class CreateChouetteLine < ActiveRecord::Migration[4.2]
  def up
    create_table "lines", :force => true do |t|
      t.integer  "network_id",                :limit => 8
      t.integer  "company_id",                  :limit => 8
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.string   "number"
      t.string   "published_name"
      t.string   "transport_mode_name"
      t.string   "registration_number"
      t.string   "comment"
      t.boolean  "mobility_restricted_suitability"
      t.integer  "int_user_needs"
    end

    add_index "lines", ["objectid"], :name => "lines_objectid_key", :unique => true
    add_index "lines", ["registration_number"], :name => "lines_registration_number_key", :unique => true
  end

  def down    
  end
end
