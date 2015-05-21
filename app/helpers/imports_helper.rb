# -*- coding: utf-8 -*-
module ImportsHelper

  def fields_for_import_task_format(form)
    begin
      render :partial => import_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

  def import_partial_name(form)
    "fields_#{form.object.format.underscore}_import"
  end

  def compliance_icon( import_task)
    return nil unless import_task.compliance_check_task
    import_task.compliance_check_task.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end

  def import_attributes_tag(import)
    content_tag :div, class: "import-attributes" do
      [].tap do |parts|
        if import.format.present?
          parts << bh_label(t("enumerize.data_format.#{import.format}"))
        end
        parts << content_tag(:div, import_save_mode_icon_tag(import), class: "save-mode")
      end.join.html_safe
    end
  end

  def import_save_mode_icon_tag(import)
    if import.no_save?
      fa_stacked_icon "database", base: "ban"
    else
      fa_icon "database"
    end
  end

end
