class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  protected

  def current_organisation
    current_user.organisation if current_user
  end
  helper_method :current_organisation

  def begin_of_association_chain
    current_organisation
  end
end
