class CreateDestinationDisplays < ActiveRecord::Migration
  def change
    create_table :destination_displays do |t|
      t.string :name, null: true
      t.string :side_text, null: true
      t.string :front_text, null: false
      t.timestamps
    end

    add_column :stop_points, :destination_display_id, :integer, null: true
    add_foreign_key :stop_points, :destination_displays, dependent: :nullify
  end
end
