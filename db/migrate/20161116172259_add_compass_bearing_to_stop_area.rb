class AddCompassBearingToStopArea < ActiveRecord::Migration[4.2]
  def change
    add_column :stop_areas, :compass_bearing, :integer, null: true
  end
end
