# -*- coding: utf-8 -*-
module ComplianceChecksHelper
  
  def fields_for_compliance_check_format(form)
    begin
      render :partial => compliance_check_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end
  
  def compliance_check_partial_name(form)
    "fields_#{form.object.format.underscore}_compliance_check"
  end
  
  def compliance_icon( compliance_check)
    return nil unless compliance_check.compliance_check_validation_report
    compliance_check.compliance_check_validation_report.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end
  
end
