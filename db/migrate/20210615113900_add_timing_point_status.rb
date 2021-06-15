class AddTimingPointStatus < ActiveRecord::Migration
  def change

    add_column :scheduled_stop_points, :timing_point_status, :string, null: true

  end
end
