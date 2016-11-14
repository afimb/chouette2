class AddCompassBearingToStopAreas < ActiveRecord::Migration
  def up
    add_column :compass_bearing, :integer, null: true, default: null
  end

  def data
  end

  def down
    remove_columns :compass_bearing
  end
end
