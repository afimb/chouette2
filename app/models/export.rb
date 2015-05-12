class Export
  include JobConcern

  def report?
    links["action_report"].present?
  end
  
  def report
    Rails.cache.fetch("#{cache_key}/action_report", expires_in: cache_expiration) do
      report_path = links["action_report"]
      if report_path
        response = Ievkit.get(report_path)
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
      Ievkit.delete(delete_path)
    elsif cancel_path
      Ievkit.delete(cancel_path)
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
  
  def format
    datas.format
  end
  
end
