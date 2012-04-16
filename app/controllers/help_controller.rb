class HelpController < ApplicationController

  def show
    @page = HelpPage.find(slug)
  end

  private

  def slug
    params[:slug] or "index"
  end

end
