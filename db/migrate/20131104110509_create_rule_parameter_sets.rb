class CreateRuleParameterSets < ActiveRecord::Migration
  def up
    unless table_exists? :rule_parameter_sets
      create_table :rule_parameter_sets do |a|
        a.integer :referential_id ,:limit => 8
        a.text :parameters
        a.string :name
        a.timestamps
      end
    end
  end

  def down
    if table_exists? :rule_parameter_sets
      execute "drop table rule_parameter_sets"
      # drop_table :rule_parameter_sets
    end
  end
end
