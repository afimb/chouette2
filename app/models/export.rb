class Export
  include JobConcern

  def initialize( response )
    @datas = response
  end
  
  def report?
    links["action_report"].present?
  end
  
  def report
    Rails.cache.fetch("#{cache_key}/action_report", expires_in: cache_expiration) do
      report_path = links["action_report"]
      if report_path
        response = Ievkitdeprecated.get(report_path)
        ExportReport.new(response)
      else
        nil
      end
    end
  end 

  def destroy
    delete_path =  links["delete"]
    cancel_path = links["cancel"]
    
    if delete_path
      Ievkitdeprecated.delete(delete_path)
    elsif cancel_path
      Ievkitdeprecated.delete(cancel_path)
    else
      nil
    end
  end

  def file_path?
    links["data"].present?
  end
  
  def file_path
    links["data"]
  end

  def filename
    File.basename(file_path) if file_path
  end

  def filename_extension
    File.extname(filename).gsub(".", "") if filename
  end

  def rule_parameter_set?
    links["validation_params"].present?
  end

  def compliance_check?
    links["validation_report"].present?
  end

  def compliance_check_validation_report
    Rails.cache.fetch("#{cache_key}/validation_report", expires_in: cache_expiration) do
      compliance_check_path = links["validation_report"]
      return nil unless compliance_check_path
      ComplianceCheckResult.new(Ievkitdeprecated.get(compliance_check_path))
    end
  end
end
