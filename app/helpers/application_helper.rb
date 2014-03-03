module ApplicationHelper

  def selected_referential?
    @referential.present? and not @referential.new_record?
  end

  def polymorphic_path_patch( source)
    relative_url_root = Rails.application.config.relative_url_root
    relative_url_root && !source.starts_with?("#{relative_url_root}/") ? "#{relative_url_root}#{source}" : source
  end
  def assets_path_patch( source)
    relative_url_root = Rails.application.config.relative_url_root
    return "/assets/#{source}" unless relative_url_root
    "#{relative_url_root}/assets/#{source}"
  end
  

  def help_page?
    controller_name == "help"
  end

  def help_path
    url_for(:controller => "/help", :action => "show") + '/'
  end
  
  
end
