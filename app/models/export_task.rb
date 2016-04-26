class ExportTask
  extend Enumerize
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Conversion

  define_model_callbacks :initialize, only: :after

  enumerize :data_format, in: %w( neptune netex gtfs hub sig )

  attr_accessor :referential_id, :user_id, :user_name, :references_type, :data_format, :name, :projection_type,
                :reference_ids, :valid_after_export, :start_date, :end_date

  validates_presence_of :referential_id
  validates_presence_of :user_id
  validates_presence_of :user_name
  validates_presence_of :name
  validates_presence_of :data_format

  validate :period_validation

  after_initialize :init_period

  def initialize( params = {} )
    run_callbacks :initialize do
      params.each {|k,v| send("#{k}=",v)}
    end
  end

  def period_validation
    st_date = start_date.present? && start_date.is_a?(String) ? Date.parse(start_date) : start_date
    ed_date = end_date.present? && end_date.is_a?(String) ? Date.parse(end_date) : end_date

    unless  Chouette::TimeTable.start_validity_period.nil? || st_date.nil?
      tt_st_date = Chouette::TimeTable.start_validity_period
      errors.add(:start_date, ExportTask.human_attribute_name("start_date_greater_than" , {:tt_st_date => tt_st_date})) unless tt_st_date <= st_date
    end
    unless st_date.nil? || ed_date.nil?
      errors.add(:end_date, ExportTask.human_attribute_name("end_date_greater_than_start_date")) unless st_date <= ed_date
    end
    unless  ed_date.nil? || Chouette::TimeTable.end_validity_period.nil?
      tt_ed_date = Chouette::TimeTable.end_validity_period
      errors.add(:end_date, ExportTask.human_attribute_name("end_date_less_than", {:tt_ed_date => tt_ed_date})) unless ed_date <= tt_ed_date
    end
  end

  def init_period
    unless Chouette::TimeTable.start_validity_period.nil?
      if start_date.nil?
        self.start_date = Chouette::TimeTable.start_validity_period
      end
      if end_date.nil?
        self.end_date = Chouette::TimeTable.end_validity_period
      end
    end
  end

  def referential
    Referential.find(referential_id)
  end

  def organisation
    referential.organisation
  end

  def save
    if self.valid?
      # Call Iev Server
      begin
        Ievkit.create_job( referential.slug, "exporter", data_format, {
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

  def self.data_formats
    self.data_format.values.select{ |format| !ENV['deactivate_formats_export'].to_s.split(',').map(&:strip).include?(format) }
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

  def self.optional_attributes(references_type)
    []
  end

  def optional_attributes
    self.class.optional_attributes(references_type.to_s)
  end

  def optional_attribute?(attribute)
    optional_attributes.include? attribute.to_sym
  end

end
