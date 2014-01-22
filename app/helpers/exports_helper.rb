module ExportsHelper

  def fields_for_export_type(form)
    partial_name = "fields_#{form.object.type.underscore}"

    begin
      render :partial => partial_name, :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

  include TypeIdsModelsHelper

end
