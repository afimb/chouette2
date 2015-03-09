class RemoveHubRestrictionsByDefaultFromOrganisations < ActiveRecord::Migration
  def change
    remove_column :organisations, :hub_restrictions_by_default
  end
end
