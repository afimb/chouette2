# This migration comes from ninoxe_engine (originally 20140626054725)
class SetInOutToTimetableDate < ActiveRecord::Migration[4.2]
  def up
    Chouette::TimeTableDate.update_all( :in_out => true)
  end

  def down
  end
end
