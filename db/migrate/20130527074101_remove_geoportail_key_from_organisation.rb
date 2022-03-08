class RemoveGeoportailKeyFromOrganisation < ActiveRecord::Migration[4.2]
  def up
    remove_column :organisations, :geoportail_key
  end

  def down
    add_column :organisations, :geoportail_key, :string
  end
end
