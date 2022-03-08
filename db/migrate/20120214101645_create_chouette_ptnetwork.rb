class CreateChouettePtnetwork < ActiveRecord::Migration[4.2]
  def up
    create_table "networks", :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.date     "version_date"
      t.string   "description"
      t.string   "name"
      t.string   "registration_number"
      t.string   "source_name"
      t.string   "source_type"
      t.string   "source_identifier"
      t.string   "comment"
    end

    add_index "networks", ["objectid"], :name => "networks_objectid_key", :unique => true
    add_index "networks", ["registration_number"], :name => "networks_registration_number_key", :unique => true
  end

  def down
  end
end
