class GtfsExport < ExportTask

  validates_presence_of :time_zone
  attr_accessor :object_id_prefix, :time_zone

  enumerize :references_type, in: %w( network line company group_of_line stop_area )
  
  after_initialize :init_params
  
  def init_params
    if time_zone.nil?
      self.time_zone = "Paris"
    end
  end

  def real_time_zone
    ActiveSupport::TimeZone.find_tzinfo(time_zone).name
  end

  def action_params
    {
      "gtfs-export" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "time_zone" => real_time_zone,
        "object_id_prefix" => object_id_prefix
      }
    }
  end

  def data_format
    "gtfs"
  end

end
