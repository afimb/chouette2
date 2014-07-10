class TimeTableCombination
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_accessor :source_id, :combined_id, :operation
  
  validates_presence_of :source_id, :combined_id, :operation
  validates_inclusion_of :operation, :in =>  %w( union intersection disjunction)

  def self.operations
    %w( union intersection disjunction)
  end

  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
    
  def persisted?  
    false  
  end 

  def combine
    source = Chouette::TimeTable.find( source_id)
    combined = Chouette::TimeTable.find( combined_id)
    puts operation
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
  end
  
end
