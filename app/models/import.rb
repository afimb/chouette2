require 'open-uri'

class Import
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model  

  attr_reader :datas

  def initialize( response  )    
    @datas = response
  end

  def links
    {}.tap do |links|
      datas.links.each do |link|
        links[link["rel"]] = link["href"] 
      end    
    end
  end
  
  def report
    report_path = links["action_report"]
    if report_path      
      response = Ievkit.get(report_path)
      ImportReport.new(response)
    else
      raise Ievkit::IevError("Impossible to access report path link for import")
    end
  end 

  def rule_parameter_set
    rule_parameter_set_path = links["validation_params"]
    if rule_parameter_set_path
      ::JSON.load( open(rule_parameter_set_path).read )
    else
      false
    end
  end
  
  def compliance_check
    compliance_check_path = links["validation_report"]
    if compliance_check_path
      response = Ievkit.get(compliance_check_path)
      ComplianceCheckResult.new(response)
    else
      raise Ievkit::Error("Impossible to access compliance check path link for import")
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
      raise Ievkit::Error("Impossible to access delete or cancel path link for import")
    end
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

  def id
    datas.id
  end

  def status
    datas.status.downcase
  end

  def format
    datas.type
  end
  
  def referential_name
    datas.referential
  end
  
  def name
    datas.action_parameters.name
  end
  
  def user_name    
    datas.action_parameters.user_name
  end

  def no_save
    datas.action_parameters.no_save
  end
  
  def created_at    
    Time.at(datas.created.to_i / 1000) if datas.created
  end

  def updated_at
    Time.at(datas.updated.to_i / 1000) if datas.updated
  end
  
end
