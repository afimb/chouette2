class ComplianceCheckResult < ActiveRecord::Base
  scope :warning, -> { where severity: 'warning' }
  scope :error, -> { where severity: 'error' }
  scope :improvment, -> { where severity: 'improvment' }

  scope :ok, -> { where status: 'ok' }
  scope :nok, -> { where status: 'nok' }
  scope :na, -> { where status: 'na' }  

  attr_accessible :violation_count
  belongs_to :compliance_check_task

  validates_presence_of :rule_code
  validates_inclusion_of :severity, :in => %w{warning error improvment}
  validates_inclusion_of :status, :in => %w{na ok nok}

  serialize :detail, JSON

  def indice
    return nil unless rule_code

    rule_code.match( /\d+-\w+-\w+-(\d+)/ )[1].to_i
  end

  def data_type
    return nil unless rule_code

    rule_code.match( /\d+-\w+-(\w+)-\d+/ )[1]
  end

  def format
    return nil unless rule_code

    rule_code.match( /\d+-(\w+)-\w+-\d+/ )[1]
  end

  def level
    return nil unless rule_code

    rule_code.match( /(\d+)-\w+-\w+-\d+/ )[1].to_i
  end

  def rule_code_formatted
    rule_code.gsub("-", "_").downcase if rule_level
  end

end
