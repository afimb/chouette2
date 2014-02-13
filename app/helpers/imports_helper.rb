# -*- coding: utf-8 -*-
module ImportsHelper

  def fields_for_import_task_format(form)
    partial_name = "fields_#{form.object.format.underscore}_import"

    begin
      render :partial => partial_name, :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
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

end
