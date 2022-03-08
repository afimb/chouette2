class AddViasDestinationDisplay < ActiveRecord::Migration[4.2]
  def change
    create_table :destination_display_via, :id => false do |t|
      t.integer  :destination_display_id, :limit => 8, :null => false
      t.integer  :via_id, :limit => 8, :null => false
      t.integer  :position, :limit => 8
      t.timestamps
    end

    add_index :destination_display_via, [:destination_display_id], :name => "index_destination_display_id_on_destination_display_via"
  end
end
