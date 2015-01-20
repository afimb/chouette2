# -*- coding: utf-8 -*-

class StopAreaCopy
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :source_id, :hierarchy, :area_type, :source, :copy
  
  validates_presence_of :source_id, :hierarchy, :area_type
  
  validates :hierarchy, inclusion: { in: %w(child parent) }
    

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) } if attributes
    if self.area_type.blank? && self.source != nil
      self.source_id = self.source.id
      if self.hierarchy == "child"
        if self.source.area_type.underscore == "stop_place"
          self.area_type="commercial_stop_point"
        else
          self.area_type="boarding_position"
        end
      else
        if self.source.area_type.underscore == "stop_place" || self.source.area_type.underscore == "commercial_stop_point"
          self.area_type="stop_place"
        else
          self.area_type="commercial_stop_point"
        end
      end
    end
  end
  
  def persisted?
    false
  end
  
  def save
    begin
      if self.valid?
        self.source ||= Chouette::StopArea.find self.source_id
        self.copy = source.duplicate
        self.copy.name = source.name
        self.copy.area_type = self.area_type.camelcase
        Chouette::StopArea.transaction do
          if self.hierarchy == "child"
            self.copy.parent_id = source.id
          end
          self.copy.save!
          if self.hierarchy == "parent"
            self.source.parent_id = copy.id
            self.source.save!
          end
        end
        true
      else
        false  
      end
    rescue Exception => exception
      Rails.logger.error(exception.message)
      errors.add :base, I18n.t("stop_area_copies.errors.exception")
      false
    end
  end   
  
  
end
