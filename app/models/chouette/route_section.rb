class Chouette::RouteSection < Chouette::TridentActiveRecord
  belongs_to :from_scheduled_stop_point, class_name: 'Chouette::ScheduledStopPoint'
  belongs_to :to_scheduled_stop_point, class_name: 'Chouette::ScheduledStopPoint'
  has_many :journey_pattern_sections
  has_many :journey_patterns, through: :journey_pattern_sections, dependent: :destroy

  validates :from_scheduled_stop_point, :to_scheduled_stop_point, presence: true
  validates :processed_geometry, presence: true

  scope :by_endpoint_name, ->(endpoint, name) do
    joins("INNER JOIN scheduled_stop_points #{endpoint}_ssp on #{endpoint}_ssp.id=route_sections.#{endpoint}_id inner join public.stop_areas #{endpoint}_sa ON #{endpoint}_sa.objectid = #{endpoint}_ssp.stop_area_objectid_key").where(["#{endpoint}_sa.name ilike ?", "%#{name}%"])
  end
  scope :by_line_id, ->(line_id) do
    joins(:journey_pattern_sections, :journey_patterns).joins('INNER JOIN routes ON journey_patterns.route_id = routes.id').where("routes.line_id = #{line_id}")
  end

  def stop_areas
    [from_scheduled_stop_point.nil? ? nil : from_scheduled_stop_point.stop_area, to_scheduled_stop_point.nil? ? nil : to_scheduled_stop_point.stop_area].compact
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

    if self.input_geometry.nil? && !self.processed_geometry.nil?
      # Accept processed geometry
      self.no_processing = false
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
