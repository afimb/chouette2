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

  def exporter
    exporter ||= ::Chouette::Exporter.new(referential.slug)
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
    { :export_id => self.id, :o => export_object_type }.tap do |options|
      options[:id] = reference_ids.join(',') if reference_ids.present?
    end
  end

  def export_object_type
    case references_type
    when "Chouette::Network"
      "ptnetwork"
    else
      references_relation ? references_relation.singularize : "line"
    end
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

      exporter.export file, export_options

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

  @@references_types = [ Chouette::Line, Chouette::Network, Chouette::Company ]
  cattr_reader :references_types

  validates_inclusion_of :references_type, :in => references_types.map(&:to_s), :all_blank => true, :allow_nil => true

  def references
    if references_relation.present? and reference_ids.present?
      referential.send(references_relation).find(reference_ids)
    else
      []
    end
  end

  def references=(references)
    unless references.blank?
      self.references_type = references.first.class.name
      self.reference_ids = references.map(&:id)
    else
      self.references_type = nil
      self.reference_ids = []
    end
  end

  def references_relation
    if references_type.present?
      relation = self.class.references_relation(references_type)
      relation if referential.respond_to?(relation)
    end
  end

  def self.references_relation(type)
    type.to_s.demodulize.underscore.pluralize 
  end

  def reference_ids
    if raw_reference_ids
      raw_reference_ids.split(',').map(&:to_i) 
    else
      []
    end
  end

  def reference_ids=(records)
    records = Array(records)
    write_attribute :reference_ids, (records.present? ? records.join(',') : nil)
  end

  def raw_reference_ids
    read_attribute :reference_ids
  end

end
