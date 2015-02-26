# class HubExport < Export

#   option :start_date
#   option :end_date
  
#   after_initialize :init_period
  
#   def init_period
#     unless Chouette::TimeTable.start_validity_period.nil?
#       if start_date.nil?
#         self.start_date = Chouette::TimeTable.start_validity_period
#       end
#       if end_date.nil?
#         self.end_date = Chouette::TimeTable.end_validity_period
#       end
#     end
#   end
  
#   def export_options
#     if (start_date.empty? && end_date.empty?)
#       super.merge(:format => :hub).except(:start_date).except(:end_date)
#     elsif start_date.empty?
#       super.merge(:format => :hub, :end_date => end_date).except(:start_date)
#     elsif end_date.empty?
#       super.merge(:format => :hub, :start_date => start_date).except(:end_date)
#     else
#       super.merge(:format => :hub, :start_date => start_date, :end_date => end_date)
#     end
#   end
  
#   def exporter
#     exporter ||= ::Chouette::Hub::Exporter.new(referential, self)
#   end

# end
