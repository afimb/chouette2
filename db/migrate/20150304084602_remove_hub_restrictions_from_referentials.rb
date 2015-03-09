class RemoveHubRestrictionsFromReferentials < ActiveRecord::Migration
  def change
    remove_column :referentials, :hub_restrictions
  end
end
