class AddVisitNumberToInterchange < ActiveRecord::Migration
  def change
    add_column :interchanges, :from_visit_number, :integer
    add_column :interchanges, :to_visit_number, :integer
  end
end
