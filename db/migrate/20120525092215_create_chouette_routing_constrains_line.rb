class CreateChouetteRoutingConstrainsLine < ActiveRecord::Migration
  def up
    create_table :routing_constraints_lines, :id => false, :force => true do |t|
      t.integer  "stop_area_id", :limit => 8
      t.integer  "line_id",     :limit => 8
    end
  end

  def down
    drop_table :routing_constraints_lines
  end
end
