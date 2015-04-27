module ValidationResultsHelper
  
  def status_icon( validation_result_result, validation_result_severity )
    if validation_result_result == "UNCHECK"
      ("<i class='fa fa-ban status_na_" + validation_result_severity.downcase  + "'></i>").html_safe
    elsif validation_result_result == "OK"
      ("<i class='fa fa-check status_ok_" + validation_result_severity.downcase + "'></i>").html_safe
    else
      ("<i class='fa fa-times status_nok_" + validation_result_severity.downcase  + "'></i>").html_safe
    end
  end
  
  def test_definition (validation_result_code)
    Rails.application.config.validation_spec + I18n.locale.to_s + "/" + validation_result_code +".html"
  end

  def object_url (referential_id, error)
    location = "/referentials/" + referential_id.to_s
    if error[:source].object_path.kind_of?(Array)
      error[:source].object_path.reverse.each { |sub_path| location = location + "/" + sub_path["type"].to_s.pluralize + "/" + sub_path["id"].to_s }
    else
      location = location + "/" + error[:source].object_path.type.to_s + "s/" + error[:source].object_path.id.to_s
    end
    return location
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
      if error[:target].kind_of?(Array)
        error[:target].each_with_index do |target, index|
          object_labels_hash["target_#{index}_objectid".to_sym] = target[:objectid] if target[:objectid]
          object_labels_hash["target_#{index}_label".to_sym] = target[:label] if target[:label]
        end
      else
        object_labels_hash[:target_0_objectid] = error[:target][:objectid] if error[:target][:objectid]
        object_labels_hash[:target_0_label] = error[:target][:label] if error[:target][:label]        
      end
    end
    if error[:error_value].present?
      object_labels_hash[:error_value] = error[:error_value]
    end
    if error[:reference_value].present?
      object_labels_hash[:reference_value] = error[:reference_value]
    end
    return object_labels_hash
  end
  
end
