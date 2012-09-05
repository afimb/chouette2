class FileValidation < ActiveRecord::Base
  validates_presence_of :resources

  validates_inclusion_of :status, :in => %w{ pending completed failed }

  attr_accessor :resources,:uncheck_count,:ok_count,:warning_count,:error_count,:fatal_count,:log_message_tree
  attr_accessor :validator

  belongs_to :organisation
  validates_presence_of :organisation

  has_many :log_messages, :class_name => "FileValidationLogMessage", :order => :position, :dependent => :destroy

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

  option :test3_1_minimal_distance
  option :test3_2_minimal_distance
  option :test3_2_polygon_points
  option :test3_7_minimal_distance
  option :test3_7_maximal_distance
  option :test3_8a_minimal_speed
  option :test3_8a_maximal_speed
  option :test3_8b_minimal_speed
  option :test3_8b_maximal_speed
  option :test3_8c_minimal_speed
  option :test3_8c_maximal_speed
  option :test3_8d_minimal_speed
  option :test3_8d_maximal_speed
  option :test3_9_minimal_speed
  option :test3_9_maximal_speed
  option :test3_10_minimal_distance
  option :test3_15_minimal_time
  option :test3_16_1_maximal_time
  option :test3_16_3a_maximal_time
  option :test3_16_3b_maximal_time
  option :test3_21a_minimal_speed
  option :test3_21a_maximal_speed
  option :test3_21b_minimal_speed
  option :test3_21b_maximal_speed
  option :test3_21c_minimal_speed
  option :test3_21c_maximal_speed
  option :test3_21d_minimal_speed
  option :test3_21d_maximal_speed
  option :projection_reference

  def validator
    @validator ||= ::Chouette::FileValidator.new("public")
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

  after_validation :extract_file_type, :on => :create
  def extract_file_type
    if !resources.original_filename.nil?
      self.file_type = resources.original_filename.rpartition(".").last
      self.file_name = resources.original_filename
    end
  end

  after_create :delayed_validate
  def delayed_validate
    save_resources
    delay.validate
  end

  @@root = "#{Rails.root}/tmp/validations"
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
    "#{FileValidation.model_name.humanize} #{id}"
  end

  def validation_options
    hash = { :validation_id => self.id ,
      :file_format => self.file_type}
    options.keys.each do |opt|
      hash.merge! opt.to_sym => self.send(opt.to_sym)
    end
    hash
  end

  def validate
    begin
      # log_messages.create :key => :started
      if resources
        with_original_filename do |file|
          # chouette-command checks the file extension (and requires .zip) :(
          validator.validate file, validation_options
        end
      else
        validator.validate saved_resources, validation_options
      end
      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Validation #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
    end
    # log_messages.create :key => status
  end

  after_find :compute_tests
  def compute_tests
    if status == 'completed'
      self.uncheck_count = 0
      self.ok_count = 0
      self.warning_count = 0
      self.error_count = 0
      self.fatal_count = 0
      self.log_message_tree = Array.new
      father1=nil
      father2=nil
      father3=nil
      log_messages.each do |message| 
        if message.level == 1
          self.log_message_tree << message
          father1=message
        elsif message.level == 2
          father1.add_child message
          father2=message
        elsif message.level == 3
          father2.add_child message
          father3=message
          if message.severity == 'uncheck'
            self.uncheck_count += 1
          end
          if message.severity == 'ok'
            self.ok_count += 1
          end
          if message.severity == 'warning'
            self.warning_count += 1
          end
          if message.severity == 'error'
            self.error_count += 1
          end
          if message.severity == 'fatal'
            self.fatal_count += 1
          end
        elsif message.level == 4
          father3.add_child message
        end
      end
    end
    
  end
  

end
