class HelpController < ApplicationController

  def show
    @page = HelpPage.find(slug)
    @toc = HelpPage.find("toc")
  end

  private

  def slug
    params[:slug] or "index"
  end

end
