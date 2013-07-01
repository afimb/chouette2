# This migration comes from ninoxe_engine (originally 20130628124932)
class RemoveProjectionFromStopAreas < ActiveRecord::Migration
  def up
    if column_exists? :stop_areas, :x
      remove_column :stop_areas, :x
    end
    if column_exists? :stop_areas, :y
      remove_column :stop_areas, :y
    end
    if column_exists? :stop_areas, :projection_type
      remove_column :stop_areas, :projection_type
    end
  end

  def down
    add_column :stop_areas, :x, :decimal,:precision => 19, :scale => 2
    add_column :stop_areas, :y, :decimal,:precision => 19, :scale => 2
    add_column :stop_areas, :projection_type, :string
  end
end
