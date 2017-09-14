class Chouette::Footnote < Chouette::TridentActiveRecord
  self.primary_key = "id"

  validates_presence_of :label
  validates_presence_of :code

  has_and_belongs_to_many :lines, :class_name => 'Chouette::Line'
  has_and_belongs_to_many :journey_patterns, :class_name => 'Chouette::JourneyPattern'
  has_and_belongs_to_many :stop_points, :class_name => 'Chouette::StopPoint'
  has_and_belongs_to_many :vehicle_journey_at_stops, :class_name => 'Chouette::VehicleJourneyAtStop'
  has_and_belongs_to_many :vehicle_journeys, :class_name => 'Chouette::VehicleJourney'

  def self.object_id_key
    "Notice"
  end

end
