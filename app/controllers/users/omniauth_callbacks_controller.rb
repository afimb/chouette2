class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    @user.confirm! unless @user.confirmed?
    
    sign_in @user
    
    if @user.organisation.present?
      redirect_to root_path
    else
      redirect_to additionnal_fields_path
    end
   
  end
end