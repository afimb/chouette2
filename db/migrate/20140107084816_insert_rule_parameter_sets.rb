class InsertRuleParameterSets < ActiveRecord::Migration
  def up
    Referential.all.each do |referential|
      RuleParameterSet.default_for_all_modes( referential).save if referential.rule_parameter_sets.empty?
    end
  end

  def down
  end
end
