class AddUserIdNameToReferential < ActiveRecord::Migration
  def change
    add_column :referentials, :user_id, :integer, :limit => 8
    add_column :referentials, :user_name, :string
  end
end
