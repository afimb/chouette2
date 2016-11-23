require 'deep_cloneable'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  before_validation :set_creation_time, if: Proc.new { |m| m.has_attribute?(:creation_time) }
  before_save :nil_if_blank, if: Proc.new { |m| m.class.methods.include?(:nullable_attributes) }

  def human_attribute_name(*args)
    self.class.human_attribute_name(*args)
  end

  def referential
    @referential ||= Referential.where(slug: Apartment::Tenant.current).first!
  end

  def format_restricted?(format)
    referential.data_format.to_sym == format.to_sym
  end

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def nil_if_blank
    self.class.nullable_attributes.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  protected

  def set_creation_time
    self.creation_time = Time.current
  end
end
