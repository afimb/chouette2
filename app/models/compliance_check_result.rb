class ComplianceCheckResult
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  
  attr_accessor :datas
  
  def initialize(response)
    @datas = response.validation_report
  end

  def tests?
    datas.tests?
  end

  def ok_error
    tests? ? tests.select { |test| (test.result == "OK" && test.severity == "ERROR") } : []
  end
  
  def nok_error
    tests? ? tests.select { |test| (test.result == "NOK" && test.severity == "ERROR")} : []
  end
  
  def na_error
    tests? ? tests.select { |test| (test.result == "UNCHECK" && test.severity == "ERROR")} : []
  end

  def ok_warning
    tests? ? tests.select { |test| (test.result == "OK" && test.severity == "WARNING")} : []
  end
  
  def nok_warning
    tests? ? tests.select { |test| (test.result == "NOK" && test.severity == "WARNING")} : []
  end
  
  def na_warning
    tests? ? tests.select { |test| (test.result == "UNCHECK" && test.severity == "WARNING")} : []
  end
  
  def all(status, severity)
    tests? ? tests.select { |test| ( test.result == status && test.severity == severity ) } : []
  end

  def tests
    [].tap do |tests|
      datas.tests.each do |test|
        tests << Test.new(test)
      end if datas.tests?
    end
  end

  class Test
    attr_reader :options
    
    def initialize( options )
      @options = options
    end

    def test_id
      options.test_id if options.test_id?
    end
    
    def severity
      options.severity.downcase if options.severity?
    end

    def result
      options.result.downcase if options.result?
    end

    def errors
      options.errors if options.errors?
    end

    def error_count
      options.error_count if options.error_count?
    end
  end
  
end
