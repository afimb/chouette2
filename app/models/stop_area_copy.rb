# -*- coding: utf-8 -*-

class StopAreaCopy
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :source_id, :hierarchy, :area_type
  
  validates_presence_of :source_id, :hierarchy, :area_type

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) } if attributes
  end
  
  def persisted?
    false
  end
  
  def save
    begin
      if self.valid?
        source = Chouette::StopArea.find self.source_id
        copy = source.duplicate
        copy.name = source.name
        copy.area_type = self.area_type.camelcase
        # TODO: check area_type validity 
        Chouette::StopArea.transaction do
          if self.hierarchy == "child"
            copy.parent_id = source.id
          end
          copy.save
          if self.hierarchy == "parent"
            source.parent_id = copy.id
            source.save
          end
        end
        true
      else
        false  
      end
    rescue Exception => exception
      Rails.logger.error(exception.message)
      errors.add :base, I18n.t("stop_area_copy.errors.exception")
      false
    end
  end   
  
  
end
