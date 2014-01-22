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

end
