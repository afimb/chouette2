class Chouette::RouteSection < ApplicationRecord
  include ObjectidRestrictions
  belongs_to :departure, class_name: 'Chouette::StopArea'
  belongs_to :arrival, class_name: 'Chouette::StopArea'
  has_many :journey_pattern_sections
  has_many :journey_patterns, through: :journey_pattern_sections, dependent: :destroy

  validates :departure, :arrival, presence: true
  validates :processed_geometry, presence: true

  scope :by_endpoint_name, ->(endpoint, name) do
    joins("INNER JOIN stop_areas #{endpoint} ON #{endpoint}.id = route_sections.#{endpoint}_id").where(["#{endpoint}.name ilike ?", "%#{name}%"])
  end
  scope :by_line_id, ->(line_id) do
    joins(:journey_pattern_sections, :journey_patterns).joins('INNER JOIN routes ON journey_patterns.route_id = routes.id').where("routes.line_id = #{line_id}")
  end

  def stop_areas
    [departure, arrival].compact
  end

  def default_geometry
    points = stop_areas.collect(&:geometry).compact
    GeoRuby::SimpleFeatures::LineString.from_points(points) if points.many?
  end

  def name
    stop_areas.map do |stop_area|
      stop_area.try(:name) or '?'
    end.join(' - ') + " (#{geometry_description})"
  end

  def via_count
    input_geometry ? [ input_geometry.points.count - 2, 0 ].max : 0
  end

  def geometry_description
    if input_geometry || processed_geometry
      [ "#{distance.to_i}m" ].tap do |parts|
        parts << "#{via_count} #{'via'.pluralize(via_count)}" if via_count > 0
      end.join(' - ')
    else
      "-"
    end
  end

  DEFAULT_PROCESSOR = Proc.new { |section| section.input_geometry || section.default_geometry.try(:to_rgeo) }

  @@processor = DEFAULT_PROCESSOR
  cattr_accessor :processor

  def instance_processor
    no_processing || processor.nil? ? DEFAULT_PROCESSOR : processor
  end

  def process_geometry
    if input_geometry_changed? || processed_geometry.nil?
      self.processed_geometry = instance_processor.call(self)
      self.distance = processed_geometry.to_georuby.to_wgs84.spherical_distance if processed_geometry
    end

    true
  end
  before_validation :process_geometry

  def editable_geometry=(geometry)
    self.input_geometry = geometry
  end

  def editable_geometry
    input_geometry.try(:to_georuby) or default_geometry
  end

  def editable_geometry_before_type_cast
    editable_geometry.to_ewkt
  end

  def geometry(mode = nil)
    mode ||= :processed
    mode == :editable ? editable_geometry : processed_geometry.to_georuby
  end

end
