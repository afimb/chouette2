class MoveStopAreaToPublic < ActiveRecord::Migration

  def up
    add_column :stop_points, :stop_area_objectid_key, :string, null: true
    add_index(:stop_points, :stop_area_objectid_key, unique: false) unless index_exists?(:stop_points, :stop_area_objectid_key)
    remove_column :stop_points, :stop_area_id

    add_column :route_sections, :arrival_stop_area_objectid_key, :string, null: true
    add_index(:route_sections, :arrival_stop_area_objectid_key, unique: false) unless index_exists?(:route_sections, :arrival_stop_area_objectid_key)
    remove_column :route_sections, :arrival_id

    add_column :route_sections, :departure_stop_area_objectid_key, :string, null: true
    add_index(:route_sections, :departure_stop_area_objectid_key, unique: false) unless index_exists?(:route_sections, :departure_stop_area_objectid_key)
    remove_column :route_sections, :departure_id

    add_column :routing_constraints_lines, :stop_area_objectid_key, :string, null: true
    add_index(:routing_constraints_lines, :stop_area_objectid_key, unique: false) unless index_exists?(:routing_constraints_lines, :stop_area_objectid_key)
    remove_column :routing_constraints_lines, :stop_area_id


  end

  def down
    add_column :stop_points, :stop_area_id, :integer, null: true
    remove_index :stop_points, [:stop_area_objectid_key] if index_exists?(:stop_points, [:stop_area_objectid_key], unique: false)
    remove_column :stop_points, :stop_area_objectid_key

    add_column :route_sections, :arrival_id, :integer, null: true
    remove_index :route_sections, [:arrival_stop_area_objectid_key] if index_exists?(:route_sections, [:arrival_stop_area_objectid_key], unique: false)
    remove_column :route_sections, :arrival_stop_area_objectid_key

    add_column :route_sections, :departure_id, :integer, null: true
    remove_index :route_sections, [:departure_stop_area_objectid_key] if index_exists?(:route_sections, [:departure_stop_area_objectid_key], unique: false)
    remove_column :route_sections, :departure_stop_area_objectid_key

    add_column :routing_constraints_lines, :stop_area_id, :string, null: true
    remove_index(:routing_constraints_lines, :stop_area_objectid_key) if index_exists?(:routing_constraints_lines, [:stop_area_objectid_key], unique: false)
    remove_column :routing_constraints_lines, :stop_area_objectid_key
  end
end
