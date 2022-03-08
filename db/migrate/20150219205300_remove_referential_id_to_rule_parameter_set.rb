class RemoveReferentialIdToRuleParameterSet < ActiveRecord::Migration[4.2]
  def up
    remove_column :rule_parameter_sets, :referential_id
  end
  def down
    add_column :rule_parameter_sets, :referential_id, :int
  end
end

