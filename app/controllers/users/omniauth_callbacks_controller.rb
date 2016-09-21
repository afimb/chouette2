class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    processAuthentification
  end

  def google_oauth2
    processAuthentification
  end

  def openid_connect
    processAuthentification
  end

  def processAuthentification
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.new_record?
      session['user_stand_by_provider'] = @user.provider
      session['user_stand_by_uid'] = @user.uid
      session['user_stand_by_name'] = @user.name
      session['user_stand_by_email'] = @user.email if @user.email.present?
    else
      sign_in @user
    end
    (@user.organisation.present? && @user.email.present?) ? (redirect_to root_path) : (redirect_to additionnal_fields_path)
  rescue Exception => e
    logger.debug e.message
    if @user
      flash[:error] = "Il est possible que vous ayez déjà un compte avec cette adresse email. Essayez de réinitialiser votre mot de passe."
    else
      flash[:error] = "Impossible de vous authentifier"
    end
    redirect_to root_path
  end
end
