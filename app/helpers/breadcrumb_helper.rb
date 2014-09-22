module BreadcrumbHelper

  def build_breadcrumb(action)
    case resource_class.to_s
    when "Chouette::Network"
      network_breadcrumb action
    when "Chouette::Company"
      company_breadcrumb action
    when "Chouette::GroupOfLine"
      group_of_line_breadcrumb action
    when "Chouette::Line"
      line_breadcrumb action
    when "Chouette::Route"
      route_breadcrumb action
    when "Chouette::JourneyPattern"
      journey_pattern_breadcrumb action
    when "Chouette::VehicleJourney"
      vehicle_journey_breadcrumb action
    when "VehicleJourneyImport"
      vehicle_journey_import_breadcrumb action
    when "Chouette::StopArea"
      stop_area_breadcrumb action
    when "Chouette::AccessPoint"
      access_point_breadcrumb action
    when "Chouette::AccessLink"
      access_link_breadcrumb action
    when "Chouette::ConnectionLink"
      connection_link_breadcrumb action
    when "Chouette::TimeTable"
      time_table_breadcrumb action
    when "ImportTask"
      import_breadcrumb action
    when "Export"
      export_breadcrumb action
    when "ComplianceCheckTask"
      compliance_breadcrumb action
    when "RuleParameterSet"
      rule_parameter_breadcrumb action
    when "User"
      user_breadcrumb action
    else
      Rails.logger.info "---------"
      Rails.logger.info ">>>>>>> "+resource_class.to_s+" unmapped"
      Rails.logger.info "---------"
      referential_breadcrumb action
    end
  end
  

  def network_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::Network.model_name.human(:count => 2), referential_networks_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@network), referential_line_path(@referential, @network),:title => breadcrumb_tooltip(@network) if action == :edit
  end

  def group_of_line_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::GroupOfLine.model_name.human(:count => 2), referential_group_of_lines_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@group_of_line), referential_group_of_line_path(@referential, @group_of_line),:title => breadcrumb_tooltip(@group_of_line) if action == :edit
  end

  def stop_area_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::StopArea.model_name.human(:count => 2), referential_stop_areas_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@stop_area), referential_stop_area_path(@referential, @stop_area),:title => breadcrumb_tooltip(@stop_area) if action == :edit
  end

  def access_point_breadcrumb(action)
    stop_area_breadcrumb :edit
    add_breadcrumb breadcrumb_label(@access_point), referential_stop_area_access_point_path(@referential, @stop_area,@access_point),:title => breadcrumb_tooltip(@access_point) if action == :edit
  end

  def access_link_breadcrumb(action)
    access_point_breadcrumb :edit
    add_breadcrumb Chouette::AccessLink.model_name.human(:count => 2), access_links_referential_stop_area_path(@referential, @stop_area)
    add_breadcrumb breadcrumb_label(@access_link), referential_access_point_access_link_path(@referential, @access_point,@access_link),:title => breadcrumb_tooltip(@access_link) if action == :edit
  end

  def connection_link_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::ConnectionLink.model_name.human(:count => 2), referential_connection_links_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@connection_link), referential_connection_link_path(@referential, @connection_link),:title => breadcrumb_tooltip(@connection_link) if action == :edit
  end

  def time_table_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::TimeTable.model_name.human(:count => 2), referential_time_tables_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@time_table), referential_time_table_path(@referential, @time_table),:title => breadcrumb_tooltip(@time_table) if action == :edit
  end

  def line_breadcrumb(action)
    referential_breadcrumb
    add_breadcrumb Chouette::Line.model_name.human(:count => 2), referential_lines_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@line), referential_line_path(@referential, @line),:title => breadcrumb_tooltip(@line) if action == :edit
  end

  def route_breadcrumb(action)
    line_breadcrumb :edit
    add_breadcrumb breadcrumb_label(@route), referential_line_route_path(@referential, @line,@route),:title => breadcrumb_tooltip(@route) if action == :edit
  end

  def journey_pattern_breadcrumb(action)
    route_breadcrumb :edit
    add_breadcrumb breadcrumb_label(@journey_pattern), referential_line_route_journey_pattern_path(@referential, @line,@route,@journey_pattern),:title => breadcrumb_tooltip(@journey_pattern) if action == :edit
  end

  def vehicle_journey_breadcrumb(action)
    route_breadcrumb :edit
    add_breadcrumb I18n.t("breadcrumbs.vehicle_journeys"), referential_line_route_vehicle_journeys_path(@referential, @line,@route) unless action == :index
    add_breadcrumb breadcrumb_label(@vehicle_journey), referential_line_route_vehicle_journey_path(@referential, @line,@route,@vehicle_journey),:title => breadcrumb_tooltip(@vehicle_journey) if action == :edit
  end
  
  def vehicle_journey_import_breadcrumb (action)
    route_breadcrumb :edit
  end

  def company_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb Chouette::Company.model_name.human(:count => 2), referential_companies_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@company), referential_company_path(@referential, @company),:title => breadcrumb_tooltip(@company) if action == :edit
  end
  
  def import_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb Referential.human_attribute_name("import_tasks"), referential_import_tasks_path(@referential) unless action == :index
  end
  
  def export_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb Referential.human_attribute_name("exports"), referential_exports_path(@referential) unless action == :index
  end

  def compliance_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential) unless action == :index
    add_breadcrumb breadcrumb_label(@compliance_check_task), referential_compliance_check_task_path(@referential, @compliance_check_task),:title => breadcrumb_tooltip(@compliance_check_task) if action == :edit
  end

  def rule_parameter_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb Referential.human_attribute_name("import_tasks"), referential_import_tasks_path(@referential) 
    add_breadcrumb Referential.human_attribute_name("compliance_check_tasks"), referential_compliance_check_tasks_path(@referential)
    add_breadcrumb Referential.human_attribute_name("rule_parameter_sets"), referential_rule_parameter_sets_path(@referential) unless action == :index
  end

  def referential_breadcrumb (action = :edit)
    add_breadcrumb I18n.t("breadcrumbs.referentials"), referentials_path 
    add_breadcrumb breadcrumb_label(@referential), referential_path(@referential),:title => breadcrumb_tooltip(@referential) if action != :index && @referential.present?
  end
  
  def user_breadcrumb (action)
    referential_breadcrumb 
    add_breadcrumb I18n.t("breadcrumbs.users"), organisation_path unless action == :index
    add_breadcrumb breadcrumb_label(@user), organisation_user_path(@user),:title => breadcrumb_tooltip(@user) unless action == :index
  end

  def breadcrumb_label(obj)
    label = breadcrumb_name(obj)
    if label.blank?
      label = obj.class.model_name.human+" "+obj.id.to_s
    end
    
    if label.length > 12
      label[0..8]+"..."
    else
      label  
    end
  end
  
  def breadcrumb_tooltip(obj)
    label = breadcrumb_name(obj)
    if label.blank?
      label = obj.class.model_name.human+" ("+obj.id.to_s+")"
    else
      label = obj.class.model_name.human+" : "+label
    end
    label
  end

  def breadcrumb_name(obj)
    label = ""
    if obj.respond_to?('name') 
      label = obj.name
    elsif obj.respond_to?('comment') 
      label = obj.comment
    end
    label    
  end

end
