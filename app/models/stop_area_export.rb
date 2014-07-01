# -*- coding: utf-8 -*-
require "csv"

class StopAreaExport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :column_names, :stop_areas
  
  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def to_csv(options = {})   
    CSV.generate(options) do |csv|      
      csv << column_names
      stop_areas.each do |stop_area|
        csv << stop_area.attributes.values_at(*column_names)
      end
    end
  end

end
