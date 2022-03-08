class AddOrganisationIdRuleParameterSet < ActiveRecord::Migration[4.2]
  def up
    add_column :rule_parameter_sets, :organisation_id, :integer, :limit => 8
  end

  def down
    remove_column :rule_parameter_sets, :organisation_id
  end
end
