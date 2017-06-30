class Chouette::DestinationDisplay < ActiveRecord::Base

  has_many :stop_points
  has_and_belongs_to_many :vias, class_name: "Chouette::DestinationDisplay", join_table: :destination_display_vias, foreign_key: :destination_display_id, association_foreign_key: :via_id
  accepts_nested_attributes_for :vias

  validates_presence_of :front_text

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def self.nullable_attributes
    [:name, :side_text]
  end

end
