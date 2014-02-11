class ComplianceCheckTask < ActiveRecord::Base
  attr_accessor :rule_parameter_set_id

  belongs_to :referential
  belongs_to :import_task

  validates_presence_of :referential
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_inclusion_of :status, :in => %w{ pending processing completed failed }

  has_many :compliance_check_results, :order => :status

  serialize :parameter_set, JSON

  include ::TypeIdsModelable

  def any_error_severity_failure?
    return false if compliance_check_results.empty? || compliance_check_results.nil?

    compliance_check_results.any? { |r| r.error_severity_failure? }
  end

  def failed?
    status == "failed"
  end
  
  def chouette_command
    Chouette::Command.new(:schema => referential.slug)
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
    if self.rule_parameter_set
      self.parameter_set = self.rule_parameter_set.parameters
      self.parameter_set_name = self.rule_parameter_set.name
    end
  end

  @@references_types = [ Chouette::Line, Chouette::Network, Chouette::Company, Chouette::GroupOfLine ]
  cattr_reader :references_types

  #validates_inclusion_of :references_type, :in => references_types.map(&:to_s), :allow_blank => true, :allow_nil => true

  after_destroy :destroy_import_task
  def destroy_import_task
    import_task.destroy if import_task
  end

  def delayed_validate
    delay.validate if import_task.blank?
  end

  def name
    "#{self.class.model_name.human} #{id}"
  end

  def levels
    [].tap do |l|
      l.concat( [1 , 2]) if self.import_task
      l << 3 if self.parameter_set
    end
  end

  def level1?
    levels.include?( 1)
  end

  def level2?
    levels.include?( 2)
  end

  def level3?
    levels.include?( 3)
  end

  def rule_parameter_set_archived
    return nil unless parameter_set
    RuleParameterSet.new( :name => parameter_set_name).tap do |rs|
      rs.parameters = parameter_set
    end
  end

  def rule_parameter_set
    return nil if self.rule_parameter_set_id.blank?
    RuleParameterSet.find( self.rule_parameter_set_id)
  end

  def chouette_command_args
    {:c => "validate", :id => id}
  end

  def validate
    begin
      chouette_command.run! chouette_command_args
      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Validation #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
    end
  end


end
