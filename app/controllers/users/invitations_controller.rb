class Users::InvitationsController < Devise::InvitationsController
  protected

  def invite_params
    params.require(:user).permit(:name, :email, :organisation_id )
  end

  def update_resource_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation, :invitation_token)
  end
end
