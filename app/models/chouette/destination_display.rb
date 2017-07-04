class Chouette::DestinationDisplay < ActiveRecord::Base

  has_many :stop_points

  has_many :destination_display_vias
  has_many :vias, :through => :destination_display_vias
  accepts_nested_attributes_for :destination_display_vias, :reject_if => :reject_set_self
  accepts_nested_attributes_for :vias, :reject_if => proc {|a| a['front_text'].blank?}
  validates_presence_of :front_text

  def reject_set_self(attributes)
    exists = attributes['destination_display_id'].present? && attributes['via_id'].present?
    is_self = attributes['destination_display_id'] == attributes['via_id']
    !exists || is_self # reject empty id or self
  end

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def self.nullable_attributes
    [:name, :side_text]
  end

end
