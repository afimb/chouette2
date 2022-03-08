class AddRuleCodePartsToCompilanceCheckResults < ActiveRecord::Migration[4.2]
  def change
    change_table :compliance_check_results do |t|
      t.string  :rule_target, :rule_format
      t.integer :rule_level, :rule_number
    end
  end
end
