# This migration comes from ninoxe_engine (originally 20130628124951)
class RemoveProjectionFromAccessPoints < ActiveRecord::Migration[4.2]
  def up
    if column_exists? :access_points, :x
      remove_column :access_points, :x
    end
    if column_exists? :access_points, :y
      remove_column :access_points, :y
    end
    if column_exists? :access_points, :projection_type
      remove_column :access_points, :projection_type
    end
  end

  def down
    add_column :access_points, :x, :decimal,:precision => 19, :scale => 2
    add_column :access_points, :y, :decimal,:precision => 19, :scale => 2
    add_column :access_points, :projection_type, :string
  end
end
