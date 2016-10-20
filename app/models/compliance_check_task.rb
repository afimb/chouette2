class ComplianceCheckTask
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  enumerize :references_type, in: %w( network line company group_of_line )
  attr_accessor :rule_parameter_set_id, :referential_id, :user_id, :user_name, :name, :references_type, :reference_ids
  
  validates_presence_of :referential_id
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_presence_of :name
  
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
      # Call Iev Server
      begin 
        Ievkitdeprecated.create_job( referential.slug, "validator", "", {
                             :file1 => params_io,
                           } )     
      rescue Exception => exception
        raise exception
      end
      true
    else
      false
    end
  end
  
  def self.references_types
    self.references_type.values
  end

  def params
    {}.tap do |h|
      h["parameters"] = validation_params ? action_params.merge(validation_params) : action_params
    end
  end

  def action_params
    {
      "validate" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
      }
      
    }
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
    File.extname(resources.original_filename)
  end

  def saved_resources_path
    "#{root}/#{Time.now.to_i}#{file_extname}"
  end
end
