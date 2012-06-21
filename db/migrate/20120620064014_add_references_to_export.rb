class AddReferencesToExport < ActiveRecord::Migration
  def change
    change_table :exports do |t|
      t.string :references_type, :reference_ids
    end
  end
end
