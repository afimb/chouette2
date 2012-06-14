# -*- coding: utf-8 -*-
module ImportsHelper

  def fields_for_import_type(form)
    partial_name = "fields_#{form.object.type.underscore}"

    begin
      render :partial => partial_name, :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

end
