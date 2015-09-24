# This migration comes from ninoxe_engine (originally 20150922093109)
class AddStableIdToLine < ActiveRecord::Migration
  def change
    change_table :lines do |t|
      t.string :stable_id
    end
  end
end
