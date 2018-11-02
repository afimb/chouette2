class ComplianceCheck
  include JobConcern

  def initialize(response)
    @datas = response
  end

  def report?
    links["action_report"].present?
  end

  def report
    if (completed?)
      Rails.cache.fetch("#{cache_key}/action_report", expires_in: cache_expiration) do
        if report_path = links["action_report"]
          ComplianceCheckReport.new Ievkitdeprecated.get(report_path)
        end
      end
    else
      if report_path = links["action_report"]
        ComplianceCheckReport.new Ievkitdeprecated.get(report_path)
      end
    end
  end

  def compliance_check_validation_report?
    links["validation_report"].present?
  end

  def compliance_check_validation_report
    Rails.cache.fetch("#{cache_key}/validation_report", expires_in: cache_expiration) do
      if report_path = links["validation_report"]
        ComplianceCheckResult.new Ievkitdeprecated.get(report_path)
      end
    end
  end

  def rule_parameter_set?
    links["validation_params"].present?
  end

  def rule_parameter_set
    Rails.cache.fetch("#{cache_key}/validation_params", expires_in: cache_expiration) do
      if rule_parameter_set_path = links["validation_params"]
        response = Ievkitdeprecated.get(rule_parameter_set_path)
        RuleParameterSet.new(name: '', compliance_check: self).tap do |rps|
          rps.parameters = response.validation
        end
      end
    end
  end

  def destroy
    if delete_path = links["delete"]
      Ievkitdeprecated.delete(delete_path)
    elsif cancel_path = links["cancel"]
      Ievkitdeprecated.delete(cancel_path)
    end
  end

  def format
    datas.type
  end
end
