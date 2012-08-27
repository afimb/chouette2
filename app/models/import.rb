class Import < ActiveRecord::Base
  belongs_to :referential

  validates_presence_of :referential_id
  validates_presence_of :resources

  validates_inclusion_of :status, :in => %w{ pending completed failed }

  attr_accessor :resources
  attr_accessor :loader

  has_many :log_messages, :class_name => "ImportLogMessage", :order => :position, :dependent => :destroy

  serialize :options

  def self.option(name)
    name = name.to_s

    define_method(name) do
      self.options and self.options[name]
    end

    define_method("#{name}=") do |prefix|
      (self.options ||= {})[name] = prefix
    end
  end

  def self.types
    # if Rails.env.development? and subclasses.blank?
    #   Dir[File.expand_path("../*_import.rb", __FILE__)].each do |f| 
    #     require f
    #   end
    # end

    unless Rails.env.development?
      subclasses.map(&:to_s)
    else
      # FIXME
      %w{NeptuneImport CsvImport}
    end
  end

  def loader
    @loader ||= ::Chouette::Loader.new(referential.slug)
  end

  def with_original_filename
    Dir.mktmpdir do |tmp_dir|
      tmp_link = File.join(tmp_dir, resources.original_filename)
      FileUtils.ln_s resources.path, tmp_link
      yield tmp_link
    end
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
  end

  before_validation :extract_file_type, :on => :create
  def extract_file_type
    if ! resources.nil? 
      self.file_type = resources.original_filename.rpartition(".").last      
    end
  end

  after_create :delayed_import
  def delayed_import
    save_resources
    delay.import
  end

  @@root = "#{Rails.root}/tmp/imports"
  cattr_accessor :root

  def save_resources
    FileUtils.mkdir_p root
    FileUtils.cp resources.path, saved_resources 
  end

  after_destroy :destroy_resources
  def destroy_resources
    FileUtils.rm saved_resources if File.exists? saved_resources
  end

  def saved_resources
    "#{root}/#{id}.#{file_type}"
  end

  def name
    "#{Import.model_name.humanize} #{id}"
  end

  def import_options
    { :import_id => self.id , :file_format => self.file_type }
  end

  def import
    begin
      log_messages.create :key => :started
      if resources
        with_original_filename do |file|
          # chouette-command checks the file extension (and requires .zip) :(
          loader.import file
        end
      else
        loader.import saved_resources, import_options
      end
      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Import #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
    end
    log_messages.create :key => status
  end

  def self.new(attributes = {}, options = {}, &block)
    if self == Import
      Object.const_get(attributes.delete(:type) || "NeptuneImport").new(attributes, options)
    else
      super
    end
  end

end
