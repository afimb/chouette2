class AddInvitableToUser < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
        t.string   :invitation_token, :limit => 60
        t.datetime :invitation_sent_at
        t.datetime :invitation_accepted_at
        t.integer  :invitation_limit
        t.integer  :invited_by_id
        t.string   :invited_by_type

    end

    # Allow null encrypted_password
    change_column :users, :encrypted_password, :string, :null => true
    # Allow null password_salt (add it if you are using Devise's encryptable module)
    #change_column :users, :password_salt, :string, :null => true
  end
end
