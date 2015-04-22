module ProgressBarHelper

  def percentage_progress(object_model, report)
    if %w{ aborted canceled terminated }.include? object_model.status
      percentage_progress = "100"
    elsif object_model.status == "started" && report.total_steps != 0
      percentage_progress = "#{report.current_step / report.total_steps}"
    else # %w{ scheduled nil }.include? object_model.status
      percentage_progress = "0"
    end      
  end
  
  def progress_bar_tag(object_model)
    report = object_model.report
    percentage_progress = percentage_progress(object_model, report)
    
    percentage_info = ""
    if %w{ aborted canceled scheduled terminated }.include? object_model.status
      percentage_info = "#{percentage_progress}% " + I18n.t("#{object_model.class.to_s.downcase.pluralize}.statuses.#{object_model.status}")
    elsif object_model.status == "started"
      percentage_info = "Niv #{report.current_level} : #{report.current_step_name.downcase}  #{report.current_step} / #{report.total_steps}"
    end
    
    if  %w{ aborted canceled }.include? object_model.status
      div_class = "progress-bar progress-bar-danger"
    elsif %w{ started scheduled }.include? object_model.status
      div_class = "progress-bar progress-bar-info"
    elsif object_model.status == "terminated"
      div_class = "progress-bar progress-bar-success"
    else
      div_class = "progress-bar"
    end      
    
    content_tag :div, :class => "progress", :title => percentage_info do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{percentage_progress}%;"  do
        "#{percentage_progress}%"
      end
    end
  end
end
