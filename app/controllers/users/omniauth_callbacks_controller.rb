class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    processAuthentification
  end

  def google_oauth2
    processAuthentification
  end
  
  def processAuthentification
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.confirm! unless @user.confirmed?
    sign_in @user
    (@user.organisation.present?) ? (redirect_to root_path) : (redirect_to additionnal_fields_path)
  end
end