class AddCompassBearingToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :compass_bearing, :integer, default: nil, null: true
  end
end
