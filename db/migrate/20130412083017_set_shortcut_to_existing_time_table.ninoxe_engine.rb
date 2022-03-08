# This migration comes from ninoxe_engine (originally 20130410100706)
class SetShortcutToExistingTimeTable < ActiveRecord::Migration[4.2]
  def up
    Chouette::TimeTable.all.each do |t|
      t.shortcuts_update
    end
  end

  def down
  end
end
