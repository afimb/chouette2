class AddReferenceToComplianceCheckTask < ActiveRecord::Migration[4.2]
  def change
    change_table :compliance_check_tasks do |t|
      t.string :references_type, :reference_ids
    end
  end
end
