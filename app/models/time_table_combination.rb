class TimeTableCombination
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_accessor :source_id, :combined_id, :combined_name, :operation, :status
  
  validates_presence_of :source_id, :combined_id, :operation, :combined_name
  validates_inclusion_of :operation, :in =>  %w( union intersection disjunction)
    
  def clean
    self.source_id = nil
    self.combined_id = nil
    self.combined_name = nil
    self.operation = nil
    self.errors.clear
    self.status = false
  end  
    
  def valid?(context = nil) 
      self.combined_name = nil if self.combined_id.blank? 
      super context
  end
  
  def invalid?(context = nil) 
      self.combined_name = nil if self.combined_id.blank? 
      super context
  end

  def self.operations
    %w( union intersection disjunction)
  end

  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
    self.status = false
  end  
    
  def persisted?  
    false  
  end 

  def combine
    self.status = false
    source = Chouette::TimeTable.find( source_id)
    combined = Chouette::TimeTable.find( combined_id)
    if operation == "union"
      source.merge! combined
    elsif operation == "intersection"
      source.intersect! combined
    elsif operation == "disjunction"
      source.disjoin! combined
    else 
      raise "unknown operation"
    end
    source.save
    self.status = true
  end
  
end
