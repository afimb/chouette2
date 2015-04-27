class ValidationReport
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  
  attr_reader :datas
  
  def initialize(response)
    @datas = response[:validation_report].tests.sort_by { |hash| [ hash[:severity], hash[:result], hash[:test_id]] }
  end

  def ok_error
    @datas.select { |test| (test[:result] == "OK" && test[:severity] == "ERROR") }
  end
  
  def nok_error
    @datas.select { |test| (test[:result] == "NOK" && test[:severity] == "ERROR")}
  end
  
  def na_error
    @datas.select { |test| (test[:result] == "UNCHECK" && test[:severity] == "ERROR")}
  end

  def ok_warning
    @datas.select { |test| (test[:result] == "OK" && test[:severity] == "WARNING")}
  end
  
  def nok_warning
    @datas.select { |test| (test[:result] == "NOK" && test[:severity] == "WARNING")}
  end
  
  def na_warning
    @datas.select { |test| (test[:result] == "UNCHECK" && test[:severity] == "WARNING")}
  end
  
  def mandatory_tests
    @datas.select { |test| test[:severity] == "ERROR"}
  end

  def optional_tests
    @datas.select { |test| test[:severity] == "WARNING"}
  end

  def ok_tests
    @datas.select { |test| test[:result] == "OK"}
  end

  def nok_tests
    @datas.select { |test| test[:result] == "NOK"}
  end

  def uncheck_tests
    @datas.select { |test| test[:result] == "UNCHECK"}
  end

  def all(status, severity)
    @datas.select { |test| ( test[:result] == status && test[:severity] == severity ) }
  end

  def validation_results
    return @datas
  end
  
end
