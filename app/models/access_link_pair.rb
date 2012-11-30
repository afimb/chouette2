class AccessLinkPair
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
    
  attr_accessor :from_access_point, :to_access_point
  
  validates_presence_of :from_access_point, :to_access_point

  def initialize(attributes = {})
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
    
  def persisted?  
    false  
  end 

  def access_point
    return nil if from_access_point.nil?
    from_access_point.access_point 
  end
  
  def stop_area
    return nil if from_access_point.nil?
    from_access_point.stop_area 
  end
  
  def in_valid?
    access_point.access_point_type != "out"
  end
  
  def out_valid?
    access_point.access_point_type != "in"
  end
  
  def in_exists?
    !from_access_point.id.nil?
  end
  def out_exists?
    !to_access_point.id.nil?
  end
end
