module RuleParameterSetsHelper

  def unique( value)
    return t("true") if value == "1"
    t "false"
  end

  def pattern(value)
    return t("rule_parameter_sets.labels.free_char") if value == "0"
    return t("rule_parameter_sets.labels.num_char") if value == "1"
    return t("rule_parameter_sets.labels.alpha_char") if value == "2"
    return t("rule_parameter_sets.labels.upper_char") if value == "3"
    return t("rule_parameter_sets.labels.lower_char") if value == "4"
  end
  
  def boolean_value(value)
    return t("true") if value == "1"
    t "false"
  end
  
end


