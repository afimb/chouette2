class Chouette::Footnote < Chouette::ActiveRecord
  belongs_to :line, inverse_of: :footnotes
  has_and_belongs_to_many :vehicle_journeys, :class_name => 'Chouette::VehicleJourney'

  validates_presence_of :line
end
