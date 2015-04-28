class GtfsExport < ExportTask

  validates_presence_of :time_zone
  attr_accessor :time_zone, :object_id_prefix

  enumerize :references_type, in: %w( all network line company groupofline stoparea )
  
  after_initialize :init_params
  
  def init_params
    if time_zone.nil?
      self.time_zone = "Paris"
    end
  end

  def time_zone=(time_zone)
    ActiveSupport::TimeZone.find_tzinfo(time_zone).name
  end

  def action_params
    {
      "gtfs-export" => {
        "name" => name,
        "references_type" => references_type,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "time_zone" => time_zone,
        "object_id_prefix" => object_id_prefix
      }
    }
  end

  def data_format
    "gtfs"
  end

end
