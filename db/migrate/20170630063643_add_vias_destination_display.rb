class AddViasDestinationDisplay < ActiveRecord::Migration
  def change
    create_table :destination_display_via, :id => false do |t|
      t.integer  :destination_display_id, :limit => 8
      t.integer  :via_id, :limit => 8
    end

    #add_reference :destination_displays, :destination_display, foreign_key: true
    #add_index :destination_display_via, [:destination_display_id], :name => "index_destination_display_id_on_destination_display_via"
  end
end
