class AddCompassBearingToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :compass_bearing, :integer, null: true
  end
end
