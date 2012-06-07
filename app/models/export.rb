class Export < ActiveRecord::Base

  belongs_to :referential
  validates_presence_of :referential_id

  validates_inclusion_of :status, :in => %w{ pending completed failed }

  has_many :log_messages, :class_name => "ExportLogMessage", :order => :position, :dependent => :destroy

  serialize :options

  def self.option(name)
    name = name.to_s

    define_method(name) do
      self.options[name]
    end

    define_method("#{name}=") do |prefix|
      self.options[name] = prefix
    end
  end

  def options
    read_attribute(:options) || write_attribute(:options, {})
  end

  @@root = "#{Rails.root}/tmp/exports"
  cattr_accessor :root

  after_destroy :destroy_file
  def destroy_file
    FileUtils.rm file if File.exists? file
  end

  def file
    "#{root}/#{id}.zip"
  end

  def name
    "#{self.class.model_name.human} #{id}"
  end

  def export_options
    { :export_id => self.id, :output_file => file }
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
  end

  after_create :delayed_export
  def delayed_export
    delay.export
  end

  def export
    FileUtils.mkdir_p root

    begin
      log_messages.create :key => :started

      # TODO
      # Make real export here

      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Export #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
    end

    log_messages.create :key => status
  end

  def self.new(attributes = {}, options = {}, &block)
    if self == Export
      Object.const_get(attributes.delete(:type) || "NeptuneExport").new(attributes, options)
    else
      super
    end
  end

end
