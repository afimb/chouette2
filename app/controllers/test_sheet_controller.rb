class TestSheetController < ApplicationController

  def show
    @page = TestSheetPage.find(slug)
    @toc = TestSheetPage.find("toc")
  end

  private

  def slug
    params[:slug] or "toc"
  end

end
