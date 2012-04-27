class CreateChouetteRoute < ActiveRecord::Migration
  def up
    create_table "route", :force => true do |t|
      t.integer  "lineid", :limit => 8
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.string   "name"
      t.string   "comment"
      t.integer   "oppositerouteid", :limit => 8
      t.string   "publishedname"
      t.string   "number"
      t.string   "direction"
      t.string   "wayback"
    end
  end

  def down
  end
end
