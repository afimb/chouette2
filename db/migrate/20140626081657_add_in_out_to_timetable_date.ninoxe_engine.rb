# This migration comes from ninoxe_engine (originally 20140625143030)
class AddInOutToTimetableDate < ActiveRecord::Migration[4.2]
  def change
    add_column "time_table_dates", "in_out", "boolean"
  end
end
