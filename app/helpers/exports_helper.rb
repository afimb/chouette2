# -*- coding: utf-8 -*-
module ExportsHelper
  
  def fields_for_export_task_format(form)
    begin
      render :partial => export_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end
  
  def export_partial_name(form)
    "fields_#{form.object.format.underscore}_export"
  end
  
  def compliance_icon( export_task)
    return nil unless export_task.compliance_check_task
    export_task.compliance_check_task.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end
  
  def export_progress_bar_tag(export)
    div_class = ""
    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{export.percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{export.percentage_progress}%;" do
        "#{export.percentage_progress}% " + I18n.t("export_tasks.statuses.#{export.status}")
      end
    end
  end
  
end
