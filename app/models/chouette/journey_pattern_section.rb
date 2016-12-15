class Chouette::JourneyPatternSection < Chouette::ActiveRecord
  belongs_to :journey_pattern
  belongs_to :route_section

  validates :journey_pattern_id, presence: true
  validates :route_section_id, presence: true
  validates :rank, presence: true, numericality: :only_integer
  validates :journey_pattern_id, uniqueness: { scope: [:route_section_id, :rank] }

  default_scope { order(:rank) }

  def self.update_by_journey_pattern_rank(journey_pattern_id, route_section_id, rank)
    jps = self.find_or_initialize_by(journey_pattern_id: journey_pattern_id, rank: rank)
    if route_section_id.present?
      jps.update_attributes(route_section_id: route_section_id)
    else
      jps.destroy
    end
  end
end
