class Export
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Model  
  
  attr_reader :datas

  def initialize(response)
    @datas = response
  end

  def report
    report_path = datas.links[:report]
    if report_path
      response = IevApi.request(:get, compliance_check_path, params)
      ExportReport.new(response)
    else
      raise IevApi::IevError("Impossible to access report path link for import")
    end
  end 

  def compliance_check
    compliance_check_path = datas.links[:validation]
    if compliance_check_path
      response = IevApi.request(:get, compliance_check_path, params)
      ComplianceCheck.new(response)
    else
      raise IevApi::IevError("Impossible to access compliance check path link for import")
    end
  end

  def delete
    delete_path =  datas.links[:delete]
    if delete_path
      IevApi.request(:delete, delete_path, params)
    else
      raise IevApi::IevError("Impossible to access delete path link for import")
    end
  end

  def cancel
    cancel_path =  datas.links[:cancel]
    if cancel_path
      IevApi.request(:delete, cancel_path, params)
    else
      raise IevApi::IevError("Impossible to access cancel path link for import")
    end
  end
  
  def id
    datas.id
  end
  
  def status
    datas.status
  end
  
  def format
    datas.format
  end

  def filename
    datas.filename
  end
  
  def filename_extension
    File.extname(filename) if filename
  end
  
  def percentage_progress
    if %w{created}.include? status
      0
    elsif %w{ terminated canceled aborted }.include? status
      100
    else
      20
    end
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

  def filename
    datas.filename
  end

  def created_at?
    datas.created?
  end
  
  def created_at
    Time.at(datas.created.to_i / 1000) if created_at?
  end

  def updated_at?
    datas.updated?
  end
  
  def updated_at
    Time.at(datas.updated.to_i / 1000) if updated_at?
  end
end
