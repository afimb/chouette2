class ExportTask
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Conversion

  define_model_callbacks :initialize, only: :after

  # TODO : Move in configuration
  @@root = "#{Rails.root}/tmp/exports"
  cattr_accessor :root

  enumerize :data_format, in: %w( neptune netex gtfs hub kml )
  attr_accessor :referential_id, :user_id, :user_name, :references_type, :data_format, :name, :projection_type, :reference_ids
  
  validates_presence_of :referential_id
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_presence_of :name
  validates_presence_of :data_format
  validates_presence_of :references_type
  
  def initialize( params = {} )
    params.each {|k,v| send("#{k}=",v)}
  end

  def referential
    Referential.find(referential_id)
  end

  def organisation
    referential.organisation
  end

  def save        
    # Call Iev Server
    begin 
      Ievkit.create_job( referential.name, "exporter", data_format, {
                          :file1 => params_io,
                        } )     
    rescue Exception => exception
      raise exception
    end
  end

  def self.data_formats
    self.data_format.values
  end

  def self.references_types
    self.references_type.values
  end

  def params
    {}.tap do |h|
      h["parameters"] = action_params
    end
  end
  
  def action_params
    {}
  end
  
  def params_io
    file = StringIO.new( params.to_json )
    Faraday::UploadIO.new(file, "application/json", "parameters.json")
  end

end
