# This migration comes from ninoxe_engine (originally 20151023083836)
class CreateTimebands < ActiveRecord::Migration
  def change
    create_table :timebands do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string :name
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
