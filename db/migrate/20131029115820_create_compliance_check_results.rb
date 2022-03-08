class CreateComplianceCheckResults < ActiveRecord::Migration[4.2]
  def up
    unless table_exists? :compliance_check_results
      create_table :compliance_check_results do |t|
        t.belongs_to :compliance_check_task , :null => :no ,:limit => 8
        t.string :rule_code      # rule code value
        t.string :severity      # warning, error, improvement
        t.string :status      # NA, OK, NOK
        t.integer :violation_count # number of violation occurences
        t.text :detail # detail of violation location
        t.timestamps
        t.foreign_key :compliance_check_tasks, :dependent => :delete
      end
    end
  end

  def down
    if table_exists? :compliance_check_results
      execute "drop table compliance_check_results"
      # drop_table :compliance_check_results
    end
  end
end
