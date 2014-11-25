module ComplianceCheckTasksHelper

  include TypeIdsModelsHelper

  def button_link_class( compliance_check_task )
    if compliance_check_task.any_error_severity_failure? || compliance_check_task.status == "failed"
      "btn-danger"
    else
      "btn-default"
    end
  end

  def compliance_check_task_progress_bar_tag(compliance_check_task)
      
    if compliance_check_task.status == "failed"
      div_class = "progress-bar progress-bar-danger"
      percentage_progress = "100"
    elsif compliance_check_task.status == "pending"
      div_class = "progress-bar progress-bar-info"
      percentage_progress = "10"
    elsif compliance_check_task.status == "processing"
      div_class = "progress-bar progress-bar-info"
      percentage_progress = "50"
    elsif compliance_check_task.status == "completed"
      div_class = "progress-bar progress-bar-success"
      percentage_progress = "100"
    else
      div_class = ""
      percentage_progress = ""
    end  

    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => percentage_progress, :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{percentage_progress}%;" do
        percentage_progress + "% " + I18n.t("compliance_check_tasks.statuses.#{compliance_check_task.status}")
      end
    end
    
  end
end
