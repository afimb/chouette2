class CreateRoutingConstraints < ActiveRecord::Migration
  def change
    create_table :routing_constraints do |t|
      t.string :name, null: false
      t.string :comment
      t.string :objectid, null: false
      t.integer :object_version
      t.datetime :creation_time
      t.string :creator_id
    end
    add_index :routing_constraints, :objectid, unique: true
  end
end
