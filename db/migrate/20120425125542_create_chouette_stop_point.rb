class CreateChouetteStopPoint < ActiveRecord::Migration
  def up
    create_table "stoppoint", :force => true do |t|
      t.integer  "routeid", :limit => 8
      t.integer  "stopareaid", :limit => 8
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"
      t.integer  "position"
    end
  end

  def down
  end
end
