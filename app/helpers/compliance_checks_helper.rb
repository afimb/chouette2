# -*- coding: utf-8 -*-
module ComplianceChecksHelper

  def fields_for_compliance_check_format(form)
    begin
      render :partial => compliance_check_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

  def compliance_check_partial_name(form)
    "fields_#{form.object.format.underscore}_compliance_check"
  end

  def compliance_icon( compliance_check)
    return nil unless compliance_check.compliance_check_validation_report
    compliance_check.compliance_check_validation_report.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end

  def status_icon( compliance_check_result_status, compliance_check_result_severity )
    if compliance_check_result_status == "uncheck"
      ("<i class='fa fa-ban status_" + compliance_check_result_status + "_" + compliance_check_result_severity  + "'></i>").html_safe
    elsif compliance_check_result_status == "ok"
      ("<i class='fa fa-check status_" + compliance_check_result_status + "_" + compliance_check_result_severity + "'></i>").html_safe
    else
      ("<i class='fa fa-times status_" + compliance_check_result_status + "_" + compliance_check_result_severity  + "'></i>").html_safe
    end
  end

  def test_definition (compliance_check_result_code)
    Rails.application.config.validation_spec + I18n.locale.to_s + "/" + compliance_check_result_code +".html"
  end

  def object_url (referential_id, error)
    location = "/referentials/" + referential_id.to_s
    object_path = error[:source].object_path
    if object_path.first[:type] == "vehicle_journey"
      object_path.delete_at 1
    end
    types, identifiers = object_path.reverse.map { |resource| [ resource[:type], resource[:id] ] }.transpose

    method_name = (['referential'] + types + ['path']).join('_')
    identifiers.unshift referential_id

    return send method_name, *identifiers
  rescue => e
    Rails.logger.error "Error: #{e.message}"
  end

  def object_labels_hash (error)
    ### THE error HASH STRUCTURE
    # 1. error[:source]
    #      0..1 file
    #           1 filename
    #           0..1 line_number
    #           0..1 column_number
    #      0..1 objectid
    #      0..1 label
    #      0..  object_path
    #           1 type
    #           1 id
    # 0.. error[:target]
    # 0..1 error[:error_value]
    # 0..1 error[:reference_value]
    object_labels_hash = Hash.new
    object_labels_hash[:source_objectid] = error[:source].objectid if error[:source].objectid.present?
    object_labels_hash[:source_label] = error[:source].label if error[:source].label.present?
    if error[:source].file.present?
      object_labels_hash[:filename] = error[:source].file.filename
      object_labels_hash[:line_number] = error[:source].file.line_number if error[:source].file.line_number.present?
      object_labels_hash[:column_number] = error[:source].file.column_number if error[:source].file.column_number.present?
    end

    if error[:target].present?
      error[:target].each_with_index do |target, index|
        object_labels_hash["target_#{index}_objectid".to_sym] = target[:objectid] if target[:objectid]
        object_labels_hash["target_#{index}_label".to_sym] = target[:label] if target[:label]
      end
    end
    if error[:error_value].present?
      object_labels_hash[:error_value] = error[:error_value]
    end
    if error[:reference_value].present?
      object_labels_hash[:reference_value] = error[:reference_value]
    end
    if error[:error_description].present?
      object_labels_hash[:error_description] = error[:error_description]
    else
      # Fallback to standard value if it nos not exist
      object_labels_hash[:error_description] = error[:reference_value]
    end
    return object_labels_hash
  end


end
