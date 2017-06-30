class AddViasDestinationDisplay < ActiveRecord::Migration
  def change
    create_table :destination_display_vias, :id => false do |t|
      t.integer  :destination_display_id, :limit => 8
      t.integer  :via_id, :limit => 8
    end
    add_index :destination_display_vias, [:destination_display_id], :name => "index_destination_display_id_on_destination_display_vias"
  end
end
