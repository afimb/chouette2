class HelpController < ActionController::Base
  layout "application"
  protect_from_forgery
  before_action :set_locale

  def set_locale
    I18n.locale = session[:language] || I18n.default_locale
  end

  def show
    @page = HelpPage.find(slug)
    @toc = HelpPage.find("toc")
  end

  private

  def slug
    params[:slug] or "index"
  end

end
