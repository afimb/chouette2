class CreateRouteSections < ActiveRecord::Migration[4.2]
  def change
    create_table :route_sections do |t|
      t.belongs_to :departure, limit: 8
      t.belongs_to :arrival, limit: 8

      t.line_string :input_geometry, srid: 4326
      t.line_string :processed_geometry, srid: 4326

      t.string   :objectid, null: false
      t.integer  :object_version
      t.datetime :creation_time
      t.string   :creator_id
    end
    add_foreign_key :route_sections, :stop_areas, column: :departure_id, dependent: :delete
    add_foreign_key :route_sections, :stop_areas, column: :arrival_id, dependent: :delete
  end
end
