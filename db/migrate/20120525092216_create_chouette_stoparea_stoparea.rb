class CreateChouetteStopareaStoparea < ActiveRecord::Migration
  def up
    create_table :stop_areas_stop_areas, :id => false, :force => true do |t|
      t.integer  "child_id",  :limit => 8
      t.integer  "parent_id", :limit => 8
    end
  end

  def down
    drop_table :stop_areas_stop_areas
  end
end
