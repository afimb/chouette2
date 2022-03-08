class AddVisitNumberToInterchange < ActiveRecord::Migration[4.2]
  def change
    add_column :interchanges, :from_visit_number, :integer
    add_column :interchanges, :to_visit_number, :integer
  end
end
