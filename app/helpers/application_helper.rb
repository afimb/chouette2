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
    path = request.env['PATH_INFO']
    target = case
    when path.include?("/help")
      ""
    when path.include?("/networks")
      "networks"
    when path.include?("/companies")
      "companies"
    when path.include?("/group_of_lines")
      "group_of_lines"
    when path.include?("/vehicle_journeys")
      "vehicle_journeys"
    when path.include?("/journey_patterns")
      "journey_patterns"
    when path.include?("/routes")
      "routes"
    when path.include?("/lines")
      "lines"
    when path.include?("/access_points")
      "access_points_links"
    when path.include?("/access_links")
      "access_points_links"
    when path.include?("/stop_areas")
      "stop_areas"
    when path.include?("/connection_links")
      "connection_links"
    when path.include?("/time_tables")
      "time_tables"
    when path.include?("/rule_parameter_set")
      "parametersets"
    when path.include?("/import_tasks")
      "imports"
    when path.include?("/exports")
      "exports"
    when path.include?("/compliance_check_tasks")
      "validations"
    else
      ""
    end
    
    url_for(:controller => "/help", :action => "show") + '/' + target
  end
  
  
end
