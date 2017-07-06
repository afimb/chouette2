class AddObjectIdDestinationDisplay < ActiveRecord::Migration
  def change
    add_column :destination_displays, :objectid, :string, :null => false
    add_column :destination_displays, :object_version, :integer, :limit => 8
    add_column :destination_displays, :creation_time, :datetime
    add_column :destination_displays, :creator_id, :string

    remove_column :destination_displays, :created_at
    remove_column :destination_displays, :updated_at
  end
end
