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
  
end
