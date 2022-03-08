class CreateChouettePtLink < ActiveRecord::Migration[4.2]
def up
  create_table "pt_links", :force => true do |t|
    t.integer  "start_of_link_id",    :limit => 8
    t.integer  "end_of_link_id",      :limit => 8
    t.integer  "route_id",      :limit => 8
    t.string   "objectid",       :null => false
    t.integer  "object_version"
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "name"
    t.string   "comment"
    t.decimal  "link_distance",  :precision => 19, :scale => 2
  end
   add_index "pt_links", ["objectid"], :name => "pt_links_objectid_key", :unique => true
  end

  def down
    drop_table :pt_links
  end
end
