module ComplianceCheckTasksHelper

  include TypeIdsModelsHelper

  def button_link_class( compliance_check_task )
    if compliance_check_task.any_error_severity_failure? || compliance_check_task.status == "failed"
      "btn-danger"
    else
      "btn-default"
    end
  end
end
