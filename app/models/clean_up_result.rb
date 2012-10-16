class CleanUpResult
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_accessor :time_table_count,:vehicle_journey_count,:journey_pattern_count,:route_count,:line_count
  attr_accessor :stop_count,:company_count,:network_count,:group_of_line_count
  
  def initialize()
    self.time_table_count = 0
    self.vehicle_journey_count = 0
    self.journey_pattern_count = 0
    self.route_count = 0
    self.line_count = 0
    self.stop_count = 0
    self.company_count = 0
    self.network_count = 0
    self.group_of_line_count = 0
  end  
    
  def persisted?  
    false  
  end 

  def notice
    a = Array.new
    a << I18n.t('clean_ups.success_tm', :count => time_table_count.to_s)
    if (vehicle_journey_count > 0) 
      a << I18n.t('clean_ups.success_vj', :count => vehicle_journey_count.to_s)
    end   
    if (journey_pattern_count > 0) 
      a << I18n.t('clean_ups.success_jp', :count => journey_pattern_count.to_s)
    end   
    if (route_count > 0) 
      a << I18n.t('clean_ups.success_r', :count => route_count.to_s)
    end   
    if (line_count > 0) 
      a << I18n.t('clean_ups.success_l', :count => line_count.to_s)
    end   
    if (company_count > 0) 
      a << I18n.t('clean_ups.success_c', :count => company_count.to_s)
    end   
    if (network_count > 0) 
      a << I18n.t('clean_ups.success_n', :count => network_count.to_s)
    end   
    if (group_of_line_count > 0) 
      a << I18n.t('clean_ups.success_g', :count => group_of_line_count.to_s)
    end   
    if (stop_count > 0) 
      a << I18n.t('clean_ups.success_sa', :count => stop_count.to_s)
    end 
    a  

  end
  
end
