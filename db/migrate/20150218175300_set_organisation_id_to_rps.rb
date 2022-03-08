class SetOrganisationIdToRps < ActiveRecord::Migration[4.2]
  def up
    RuleParameterSet.where(organisation_id: nil).update_all "name = concat(name, ' ', id)"

    # RuleParameterSet.joins(...).update_all("organisation_id = referentials.organisation_id")
    # fails (see https://github.com/rails/arel/pull/294)
    execute "UPDATE rule_parameter_sets SET organisation_id = referentials.organisation_id FROM referentials WHERE referentials.id = rule_parameter_sets.referential_id;"
  end

  def down
    RuleParameterSet.update_all organisation_id: nil
  end
end
