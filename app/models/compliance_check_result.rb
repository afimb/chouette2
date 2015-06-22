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
    all('ok', 'error')
  end

  def nok_error
    all('nok', 'error')
  end

  def na_error
    all('uncheck', 'error')
  end

  def ok_warning
    all('ok', 'warning')
  end

  def nok_warning
    all('nok', 'warning')
  end

  def na_warning
    all('uncheck', 'warning')
  end

  def all(status, severity)
    tests? ? tests.select { |test| test.result == status.downcase && test.severity == severity.downcase } : []
  end

  def tests
    @tests ||= tests? ? datas.tests.map{ |test| Test.new(test) } : []
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
