# -*- coding: utf-8 -*-
module ValidationsHelper
  
  def fields_for_validation_task_format(form)
    begin
      render :partial => validation_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end
  
  def validation_partial_name(form)
    "fields_#{form.object.format.underscore}_validation"
  end
  
  def compliance_icon( validation_task)
    return nil unless validation_task.compliance_check_task
    validation_task.compliance_check_task.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end
  
  def validation_progress_bar_tag(validation)
    div_class = ""
    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{validation.percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{validation.percentage_progress}%;" do
        "#{validation.percentage_progress}% " + I18n.t("validation_tasks.statuses.#{validation.status}")
      end
    end
  end

end
