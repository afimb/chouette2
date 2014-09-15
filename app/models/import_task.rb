class ImportTask < ActiveRecord::Base
  attr_accessor :resources, :rule_parameter_set_id

  belongs_to :referential

  has_one :user
  has_one :compliance_check_task, :dependent => :delete

  serialize :parameter_set, JSON
  serialize :result, JSON

  validates_presence_of :referential_id
  validates_presence_of :resources
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_inclusion_of :status, :in => %w{ pending processing completed failed }

  def references_types
    []
  end

  protected

  def self.option(name, type=nil)
    name = name.to_s

    define_method(name) do
      self.parameter_set and self.parameter_set[name]
    end

    if type.to_s == "boolean"
      define_method("#{name}=") do |prefix|
        (self.parameter_set ||= {})[name] = (prefix=="1" || prefix==true)
      end
    else
      define_method("#{name}=") do |prefix|
        (self.parameter_set ||= {})[name] = prefix
      end
    end
  end

  public

  def self.formats
    %w{Neptune Csv Gtfs Netex}
  end

  def self.format_label(format)
    I18n.t 'exchange.format.'+format.downcase
  end

  def delayed_import
    delay.import
  end

  def save_requested?
    !parameter_set["no_save"]
  end

  protected

  option :no_save, :boolean
  option :format
  option :file_path
  option :references_type

  validates_inclusion_of :no_save, :in => [ true, false]
  validates_inclusion_of :format, :in => self.formats

  def chouette_command
    Chouette::Command.new(:schema => referential.slug)
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
  end

  @@root = "#{Rails.root}/tmp/imports"
  cattr_accessor :root

  def compliance_check_task_attributes
    {:referential_id => referential.id,
     :user_id => user_id,
     :user_name => user_name,
     :rule_parameter_set_id => rule_parameter_set_id}
  end

  after_create :update_info, :save_resources
  def update_info
    self.file_path = saved_resources
    self.update_attribute :parameter_set, self.parameter_set

    self.create_compliance_check_task( self.compliance_check_task_attributes)
  end

  def save_resources
    # resources is a required attribute
    FileUtils.mkdir_p root
    FileUtils.cp resources.path, saved_resources
  end

  after_destroy :destroy_resources
  def destroy_resources
    FileUtils.rm file_path if File.exists? file_path
  end

  def saved_resources
    raise Exception.new("Illegal call") if self.new_record?
    "#{root}/#{id}#{File.extname(resources.original_filename)}"
  end

  def chouette_command_args
    {:c => "import", :id => id}
  end

  public

  def failed?
    status == "failed"
  end

  def completed?
    status == "completed"
  end

  def file_path_extension
    extension = File.extname( self.file_path )
    if extension == ".xml"
      "xml"
    elsif extension == ".zip"
      "zip"
    else
      "basic"
    end
  end

  def name
    "#{ImportTask.model_name.human} #{self.format} #{self.id}"
  end

  def full_name
    return name unless no_save
    "#{name} - #{I18n.t('activerecord.attributes.import_task.no_save')}"
  end

  # Create ImportTask and ComplianceCheckTask associated and give import id to Chouette Loader
  def import
    return nil if self.new_record?

    begin
      chouette_command.run! chouette_command_args
      reload
      update_attribute :status, "completed"
      compliance_check_task.update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Import #{id} failed : #{e}, #{e.backtrace}"
      reload
      update_attribute :status, "failed"
      compliance_check_task.update_attribute :status, "failed"
    end
  end

  def self.new(attributes = {}, parameter_set = {}, &block)
    if self == ImportTask
      attributes[:format] = "Neptune" unless attributes[:format]
      Object.const_get( attributes[:format] + "Import").new(attributes, parameter_set)
    else
      super
    end
  end

end
