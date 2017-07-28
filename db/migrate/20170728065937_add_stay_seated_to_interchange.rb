class AddStaySeatedToInterchange < ActiveRecord::Migration
  def change
    add_column :interchanges, :stay_seated, :boolean
  end
end
