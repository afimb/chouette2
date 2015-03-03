# -*- coding: utf-8 -*-
module ImportsHelper

  def fields_for_import_task_format(form)
    #partial_name = "fields_#{form.object.format.underscore}_import"

    begin
      render :partial => import_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end
  
  def import_partial_name(form)
    "fields_#{form.object.format.underscore}_import"
  end

  def compliance_icon( import_task)
    return nil unless import_task.compliance_check_task
    import_task.compliance_check_task.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end

  def import_progress_bar_tag(import)
      
    if import.canceled? || import.aborted?
      div_class = "progress-bar progress-bar-danger"
    elsif import.scheduled?
      div_class = "progress-bar progress-bar-info"
    elsif import.created?
      div_class = "progress-bar progress-bar-info"
    elsif import.terminated?
      div_class = "progress-bar progress-bar-success"
    else
      div_class = ""
    end  

    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{import.percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{import.percentage_progress}%;" do
        "#{import.percentage_progress}% " + I18n.t("import_tasks.statuses.#{import.status}")
      end
    end
    
  end

end
