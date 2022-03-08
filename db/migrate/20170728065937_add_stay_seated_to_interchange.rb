class AddStaySeatedToInterchange < ActiveRecord::Migration[4.2]
  def change
    add_column :interchanges, :stay_seated, :boolean
  end
end
