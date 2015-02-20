class AddHubRestrictionsToOrganisation < ActiveRecord::Migration
  def self.up
    add_column :organisations, :hub_restrictions_by_default, :boolean
    add_column :referentials, :hub_restrictions, :boolean
  end
  def self.down
    remove_column :organisations, :hub_restrictions_by_default
    remove_column :referentials, :hub_restrictions
  end
end
