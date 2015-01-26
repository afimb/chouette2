class AddHubRestrictionsToOrganisation < ActiveRecord::Migration
  def change
    change_table :organisations do |t|
      t.boolean :hub_restrictions
    end
  end
end
