class CreateBranding < ActiveRecord::Migration[4.2]
  def change
    create_table :brandings, :force => true do |t|
      t.string   "objectid",                  null: false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id",                limit: 255
      t.string   "name"
      t.string   "description"
      t.string   "url"
      t.string   "image"
    end
    add_index "brandings", ["objectid"], :name => "brandings_objectid_key", :unique => true
  end
end
