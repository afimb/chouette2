class AddNameToUser < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      t.string :name
    end
  end
end
