module ApplicationHelper

  def selected_referential?
    @referential.present? and not @referential.new_record?
  end

  def help_page?
    controller_name == "help"
  end

  def test_sheet_page?
    controller_name == "test_sheet"
  end

  def help_path
    url_for(:controller => "/help", :action => "show") + '/'
  end
  
  def test_sheet_path
    url_for(:controller => "/test_sheet", :action => "show") + '/'
  end
  
end
