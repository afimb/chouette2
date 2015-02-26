# class GtfsExport < Export

#   validates_presence_of :time_zone
#   option :time_zone
#   option :object_id_prefix
  
#   after_initialize :init_params
  
#   def references_types
#     [ Chouette::Line, Chouette::Network, Chouette::Company, Chouette::StopArea ]
#   end

#   def init_params
#     if time_zone.nil?
#       self.time_zone = "Paris"
#     end
#   end
  
#   def export_options
#     opts = super.merge(:format => :gtfs, :time_zone => ActiveSupport::TimeZone.find_tzinfo(time_zone).name)
#     if object_id_prefix.present?
#       opts = opts.merge(:object_id_prefix => object_id_prefix)
#     end
#     puts opts.inspect
#     opts
#   end

# end
