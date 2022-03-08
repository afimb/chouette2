class RemoveHubRestrictionsByDefaultFromOrganisations < ActiveRecord::Migration[4.2]
  def change
	 if column_exists? :organisations, :hub_restrictions_by_default
      remove_column :organisations, :hub_restrictions_by_default
	 end
  end
end
