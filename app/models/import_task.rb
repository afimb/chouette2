require "zip"

class ImportTask
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  # TODO : Move in configuration
  @@root = "#{Rails.root}/tmp/imports"
  cattr_accessor :root

  enumerize :data_format, in: %w( neptune netex gtfs regtopp)
  attr_accessor :rule_parameter_set_id, :referential_id, :user_id, :user_name, :data_format, :resources, :name, :no_save

  validates_presence_of :referential_id
  validates_presence_of :resources
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_presence_of :name

  validate :validate_file_size, :validate_file_content

  def initialize( params = {} )
    params.each {|k,v| send("#{k}=",v)}
  end

  def referential
    Referential.find(referential_id)
  end

  def organisation
    referential.organisation
  end

  def rule_parameter_set
    organisation.rule_parameter_sets.find(rule_parameter_set_id) if rule_parameter_set_id.present?
  end

  def save
    if valid?
      # Save resources
      save_resources

      # Call Iev Server
      begin
        Ievkit.create_job(referential.slug, "importer", data_format, {
                            :file1 => params_io,
                            :file2 => transport_data_io
                          }

                         )

        # Delete resources
        delete_resources
      rescue Exception => exception
        # If iev server has an error must delete resources before
        delete_resources

        raise exception
      end
      true
    else
      false
    end
  end

  def params
    {}.tap do |h|
      h["parameters"] = validation_params ? action_params.merge(validation_params) : action_params
    end
  end

  def action_params
    {}
  end

  def validation_params
    {
      "validation" => rule_parameter_set.parameters
    } if rule_parameter_set.present?
  end

  def self.data_formats
    self.data_format.values
  end

  def params_io
    file = StringIO.new( params.to_json )
    Faraday::UploadIO.new(file, "application/json", "parameters.json")
  end

  def transport_data_io
    file = File.new(saved_resources_path, "r")
    if file_extname == ".zip"
      Faraday::UploadIO.new(file, "application/zip", original_filename )
    elsif file_extname == ".xml"
      Faraday::UploadIO.new(file, "application/xml", original_filename )
    end
  end

  def save_resources
    FileUtils.mkdir_p root
    FileUtils.cp resources.path, saved_resources_path
  end

  def delete_resources
    FileUtils.rm saved_resources_path if File.exists? saved_resources_path
  end

  def original_filename
    resources.original_filename
  end

  def file_extname
    File.extname(original_filename) if original_filename
  end

  def saved_resources_path
    @saved_resources_path ||= "#{root}/#{Time.now.to_i}#{file_extname}"
  end

  @@maximum_file_size = 80.megabytes
  cattr_accessor :maximum_file_size

  def validate_file_size
    return unless resources.present? and resources.path.present? and File.exists? resources.path

    if File.size(resources.path) > maximum_file_size
      message = I18n.t("activemodel.errors.models.import_task.attributes.resources.maximum_file_size", file_size:   ActionController::Base.helpers.number_to_human_size(File.size(resources.path)), maximum_file_size: ActionController::Base.helpers.number_to_human_size(maximum_file_size))
      errors.add(:resources, message)
    end
  end

  @@valid_mime_types = {
    neptune: %w{application/zip application/xml},
    netex: %w{application/zip},
    gtfs: %w{application/zip  text/plain},
    regtopp: %w{application/zip}
  }
  cattr_accessor :valid_mime_types

  def validate_file_content
    return unless resources.present? and resources.path.present? and File.exists? resources.path

    mime_type = (File.open(resources.path) { |f| MimeMagic.by_magic f }).try :type
    expected_mime_types = valid_mime_types[data_format.to_sym]

    unless expected_mime_types.include? mime_type
      message = I18n.t("activemodel.errors.models.import_task.attributes.resources.invalid_mime_type", mime_type: mime_type)
      errors.add(:resources, message)
    end
  end

end
