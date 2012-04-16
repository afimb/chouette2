module ApplicationHelper

  def selected_referential?
    @referential.present? and not @referential.new_record?
  end

  def help_page?
    controller_name == "help"
  end

  def help_path
    url_for(:controller => "/help", :action => "show") + '/'
  end
  
end
