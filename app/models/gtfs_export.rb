class GtfsExport < Export

  validates_presence_of :time_zone
  option :time_zone
  
  after_initialize :init_time_zone
  
  def init_time_zone
    if time_zone.nil?
      self.time_zone = "Paris"
    end
  end
  
  def export_options
    super.merge(:format => :gtfs, :time_zone => ActiveSupport::TimeZone.find_tzinfo(time_zone).name)
  end

end
