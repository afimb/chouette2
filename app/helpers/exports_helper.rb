# -*- coding: utf-8 -*-
module ExportsHelper

  def fields_for_export_format(form)
    #partial_name = "fields_#{form.object.format.underscore}"

    begin
      render :partial => export_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end
  
  def export_partial_name(form)
    "fields_#{form.object.format.underscore}"
  end
  
  def export_progress_bar_tag(export)
    
    if export.canceled? || export.aborted?
      div_class = "progress-bar progress-bar-danger"
    elsif export.scheduled?
      div_class = "progress-bar progress-bar-info"
    elsif export.created?
      div_class = "progress-bar progress-bar-info"
    elsif export.terminated?
      div_class = "progress-bar progress-bar-success"
    else
      div_class = ""
    end  

    content_tag :div, :class => "progress" do
      content_tag :div, :class => div_class, role: "progressbar", :'aria-valuenow' => "#{export.percentage_progress}", :'aria-valuemin' => "0", :'aria-valuemax' => "100", :style => "width: #{export.percentage_progress}%;" do
        "#{export.percentage_progress}% " + I18n.t("exports.statuses.#{export.export_status}")
      end
    end
    
  end

end
