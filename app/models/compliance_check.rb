class ComplianceCheck
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model  
  attr_reader :datas
  
  def initialize(response)    
    @datas = response
  end
  
  def links
    {}.tap do |links|
      datas.links.each do |link|
        links[link["rel"]] = link["href"] 
      end    
    end
  end
  
  def compliance_check_result
    report_path = links["validation_report"]
    if report_path      
      response = Ievkit.get(report_path)
      ComplianceCheckResult.new(response)
    else
      raise Ievkit::IevError("Impossible to access report path link for validation")
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

  def destroy
    delete_path =  links["delete"]
    cancel_path = links["cancel"]
    
    if delete_path
      Ievkit.delete(delete_path)
    elsif cancel_path
      Ievkit.delete(cancel_path)
    else
      raise Ievkit::Error("Impossible to access delete or cancel path link for compliance check")
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

  def percentage_progress
    if %w{created}.include? status
      0
    elsif %w{ terminated canceled aborted }.include? status
      100
    else
      20
    end
  end

end
