# coding: utf-8
module ProgressBarHelper
  
  def progress_bar_tag(object_model)
    report = object_model.report   
    
    if  %w{ aborted canceled }.include? object_model.status
      div_class = "progress-bar progress-bar-danger"
    elsif %w{ started scheduled }.include? object_model.status
      div_class = "progress-bar progress-bar-striped active progress-bar-info"
    elsif object_model.status == "terminated"
      div_class = "progress-bar progress-bar-success"
    else
      div_class = "progress-bar"
    end

    if object_model.status != "terminated"
      progress = content_tag :div, :class => "progress" do
        concat(content_tag(:div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{report.level_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{report.level_progress}%;") do               
             end)
        concat( content_tag(:span, t("progress_bar.level"), :class => "progress-type") )
        concat( content_tag(:span, "#{report.progression.current_step}/#{report.progression.steps_count}", :class => "progress-completed") )
      end
    
      progress += content_tag :div, :class => "progress" do 
        concat(content_tag( :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{report.step_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: 100%;" ) do
             end)
        concat( content_tag(:span, t("progress_bar.step"), :class => "progress-type") )
        concat( content_tag(:span, "#{report.current_step.realized}/#{report.current_step.total}", :class => "progress-completed") )
      end
    end
    
  end
end
