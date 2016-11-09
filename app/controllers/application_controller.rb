class ApplicationController < ActionController::Base
  # TODO : Delete hack to authorize Cross Request for js and json get request from javascript
  include Pundit
  protect_from_forgery unless: -> { request.get? && (request.format.json? || request.format.js?) }
  before_action :authenticate_user!
  before_action :set_locale

  # Load helpers in rails engine
  helper LanguageEngine::Engine.helpers

  def set_locale
    I18n.locale = session[:language] || I18n.default_locale
  end

  protected

  def check_authorize
    raise "not authorized" unless authorize :application, :write?
  end

  def check_authorize_admin
    raise "not authorized" unless authorize :application, :admin?
  end

  def current_organisation
    current_user.organisation if current_user
  end
  helper_method :current_organisation

  def begin_of_association_chain
    current_organisation
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
