class CreateRoutingConstraintsStopAreas < ActiveRecord::Migration
  def change
    create_table :routing_constraints_stop_areas, id: false do |t|
      t.belongs_to :routing_constraint, index: true, foreign_key: true
      t.belongs_to :stop_area, index: true, foreign_key: true
    end
  end
end
