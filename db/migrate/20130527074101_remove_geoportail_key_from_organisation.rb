class RemoveGeoportailKeyFromOrganisation < ActiveRecord::Migration
  def up
    remove_column :organisations, :geoportail_key
  end

  def down
    add_column :organisations, :geoportail_key, :string
  end
end
