class AddMinimumTransferTime < ActiveRecord::Migration
  def change
    add_column :interchanges, :minimum_transfer_time, :time
  end
end
