class CreateChouetteGroupOfLine < ActiveRecord::Migration
  def up
    create_table :group_of_lines, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
    end
   add_index "group_of_lines", ["objectid"], :name => "group_of_lines_objectid_key", :unique => true
  end

  def down
    drop_table :group_of_lines
  end
end
