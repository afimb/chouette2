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
  
  def source
    @source ||= Chouette::StopArea.find self.source_id
  end

  def copy
    @copy ||= self.source.duplicate
  end

  def copy_is_source_parent?
    self.hierarchy == "parent"
  end

  def copy_is_source_child?
    self.hierarchy == "child"
  end

  def copy_modfied_attributes
    { :name => self.source.name, # TODO: change ninoxe to avoid that !!!
      :area_type => self.area_type.camelcase,
      :registration_number => nil,
      :parent_id => copy_is_source_child? ? self.source_id : self.copy.parent_id
    }
  end

  def source_modified_attributes
    return {} unless copy_is_source_parent?
    { :parent_id => self.copy.id
    }
  end

  def save
    begin
      if self.valid?
        Chouette::StopArea.transaction do
          copy.update_attributes copy_modfied_attributes
          unless source_modified_attributes.empty?
            source.update_attributes source_modified_attributes
          end
        end
        true
      else
        false
      end
    rescue Exception => exception
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
      errors.add :base, I18n.t("stop_area_copies.errors.exception")
      false
    end
  end
  
end
