class CreateRoutingConstraintsLines < ActiveRecord::Migration
  def up
    rename_table :routing_constraints_lines, :routing_constraints_lines_previous
    create_table :routing_constraints_lines, id: false do |t|
      t.belongs_to :routing_constraint, index: true, foreign_key: true
      t.belongs_to :line, index: true, foreign_key: true
    end
  end

  def down
    drop_table :routing_constraints_lines
    create_table :routing_constraints_lines, id: false, force: true do |t|
      t.integer  :stop_area_id
      t.integer  :line_id
    end
  end
end
