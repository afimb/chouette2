class RemoveHubRestrictionsFromReferentials < ActiveRecord::Migration
  def change
	 if column_exists? :referentials, :hub_restrictions
      remove_column :referentials, :hub_restrictions
	 end
  end
end
