class InvitationsController < Devise::InvitationsController

  def update
    if this
      redirect_to organisation_path
    else
      super
    end
  end

  protected
  
  def invite_params
    params.require(:user).permit(:name, :email )
  end

  def update_resource_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation, :invitation_token)
  end  
  
end
