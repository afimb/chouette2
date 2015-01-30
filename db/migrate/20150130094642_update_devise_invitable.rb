class UpdateDeviseInvitable < ActiveRecord::Migration
  def up
    change_column :users, :invitation_token, :string, :limit => nil    
    add_column :users, :invitation_created_at, :datetime    
    add_index :users, :invitation_token, :unique => true    
  end
  
  def down
    change_column :users, :invitation_token, :string, :limit => 60
    drop_column :users, :invitation_created_at
    drop_index :users, :invitation_token
  end
end
