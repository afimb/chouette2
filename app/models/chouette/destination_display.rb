class Chouette::DestinationDisplay < ActiveRecord::Base

  has_many :stop_points

  validates_presence_of :front_text

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def self.nullable_attributes
    [:name, :side_text]
  end

end
