class AddMinimumTransferTime < ActiveRecord::Migration[4.2]
  def change
    add_column :interchanges, :minimum_transfer_time, :time
  end
end
