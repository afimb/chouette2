class RemoveHubRestrictionsByDefaultFromOrganisations < ActiveRecord::Migration
  def change
	 if column_exists? :organisations, :hub_restrictions_by_default
      remove_column :organisations, :hub_restrictions_by_default
	 end
  end
end
