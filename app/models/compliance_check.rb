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

  def report
    report_path = links["action_report"]
    if report_path      
      response = Ievkit.get(report_path)
      ComplianceCheckReport.new(response)
    else
      raise Ievkit::IevError("Impossible to access report path link for compliance check")
    end
  end
  
  def compliance_check_validation_report
    report_path = links["validation_report"]
    if report_path      
      response = Ievkit.get(report_path)
      ComplianceCheckResult.new(response)
    else
      raise Ievkit::IevError("Impossible to access report path link for validation")
    end
  end

  def rule_parameter_set
    rule_parameter_set = links["validation_params"]
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
    datas.status.downcase
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

  def created_at
    Time.at(datas.created.to_i / 1000) if datas.created
  end

  def updated_at
    Time.at(datas.updated.to_i / 1000) if datas.updated
  end

end
