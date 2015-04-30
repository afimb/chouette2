class ComplianceCheckTask
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model  
  attr_reader :datas
  
  def initialize(response)    
    @datas = response
  end
  
  def compliance_check_result
    report_path = datas.links.select{ |link| link["rel"] == "validation_report"}.first.href
    if report_path      
      response = Ievkit.get(report_path)
      ComplianceCheckResult.new(response)
    else
      raise Ievkit::IevError("Impossible to access report path link for validation")
    end
  end
  
  def import_task
    if datas.action == "importer"
      Import.new(Ievkit.scheduled_job(referential_name, id, { :action => "importer" }) )
    end
  end

  def export_task
    if datas.action == "exporter"
      Export.new(Ievkit.scheduled_job(referential_name, id, { :action => "exporter" }) )
    end
  end

  def rule_parameter_set
    rule_parameter_set = datas.links.select{ |link| link["rel"] == "validation_params"}.first.href
    if rule_parameter_set
      response = Ievkit.get(rule_parameter_set)
      rule_parameter_set = RuleParameterSet.new.tap { |rps| rps.parameters = response.validation }
    else
      raise Ievkit::Error("Impossible to access rule parameter set link for validation")
    end
  end
  
  def compliance_check
    compliance_check_path = datas.links.select{ |link| link["rel"] == "validation_report"}.first.href
    if compliance_check_path
      response = Ievkit.get(compliance_check_path)
      ComplianceCheck.new(response)
    else
      raise Ievkit::Error("Impossible to access compliance check path link for validation")
    end
  end

  def delete
    delete_path =  datas.links.select{ |link| link["rel"] == "delete"}.first.href
    if delete_path
      Ievkit.delete(delete_path)
    else
      raise Ievkit::Error("Impossible to access delete path link for validation")
    end
  end

  def cancel
    cancel_path = datas.links.select{ |link| link["rel"] == "cancel"}.first.href
    if cancel_path
      Ievkit.delete(cancel_path)
    else
      raise Ievkit::Error("Impossible to access cancel path link for validation")
    end
  end

  def id
    datas.id
  end

  def status
    # pending processing completed failed
    # CREATED, SCHEDULED, STARTED, TERMINATED, CANCELED, ABORTED, DELETED
    if datas.status == "CREATED"
      "pending"
    elsif datas.status == "SCHEDULED"
      "pending"
    elsif datas.status == "STARTED"
      "processing"
    elsif datas.status == "TERMINATED"
      "completed"
    elsif datas.status == "CANCELED"
      "failed"
    elsif datas.status == "ABORTED"
      "failed"
    elsif datas.status == "DELETED"
      "failed"
    end
  end

  def format
    datas.type
  end

  def referential_id
    Referential.where(:slug => referential_name).id
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
