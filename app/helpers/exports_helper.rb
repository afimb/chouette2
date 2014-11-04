module ExportsHelper

  def fields_for_export_type(form)
    #partial_name = "fields_#{form.object.type.underscore}"

    begin
      render :partial => export_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

  def export_partial_name(form)
    "fields_#{form.object.type.underscore}"
  end

  include TypeIdsModelsHelper

  def export_progress_bar_tag(export)
    
    if export.status == "failed"
      div_class = "progress-bar progress-bar-danger"
      percentage_progress = "100"
    elsif export.status == "pending"
      div_class = "progress-bar progress-bar-info"
      percentage_progress = "10"
    elsif export.status == "processing"
      div_class = "progress-bar progress-bar-info"
      percentage_progress = "50"
    elsif export.status == "completed"
      div_class = "progress-bar progress-bar-success"
      percentage_progress = "100"
    else
      div_class = ""
      percentage_progress = ""
    end  

    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => percentage_progress, :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{percentage_progress}%;" do
        percentage_progress + "% " + I18n.t("exports.statuses.#{export.status}")
      end
    end
    
  end
  
end
