class Chouette::DestinationDisplay < ActiveRecord::Base

  has_many :stop_points

  has_many :destination_display_vias
  has_many :vias, :through => :destination_display_vias
  accepts_nested_attributes_for :destination_display_vias, :reject_if => proc { |a| a['destination_display_id'].blank? }
  accepts_nested_attributes_for :vias #, :reject_if => proc {|a| a['name'].blank?}

  validates_presence_of :front_text

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def self.nullable_attributes
    [:name, :side_text]
  end

end
