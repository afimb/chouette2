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
    return nil unless compliance_check.compliance_check_result
    compliance_check.compliance_check_result.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end
  
  def compliance_check_progress_bar_tag(compliance_check)
    div_class = ""
    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{compliance_check.percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{compliance_check.percentage_progress}%;" do
        "#{compliance_check.percentage_progress}% " + I18n.t("compliance_checks.statuses.#{compliance_check.status}")
      end
    end
  end

end
