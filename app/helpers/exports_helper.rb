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

end
