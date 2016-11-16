class Chouette::ConnectionLink < Chouette::ActiveRecord
  include ObjectidRestrictions
  include ConnectionLinkRestrictions
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  attr_accessor :connection_link_type

  belongs_to :departure, :class_name => 'Chouette::StopArea'
  belongs_to :arrival, :class_name => 'Chouette::StopArea'

  validates_presence_of :name

  def self.nullable_attributes
    [:link_distance, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration,
      :mobility_restricted_traveller_duration, :link_type]
  end

  def connection_link_type
    link_type && Chouette::ConnectionLinkType.new( link_type.underscore)
  end

  def connection_link_type=(connection_link_type)
    self.link_type = (connection_link_type ? connection_link_type.camelcase : nil)
  end

  @@connection_link_types = nil
  def self.connection_link_types
    @@connection_link_types ||= Chouette::ConnectionLinkType.all
  end

  def possible_areas
    Chouette::StopArea.where("area_type != 'ITL'")
  end

  def stop_areas
    Chouette::StopArea.where(:id => [self.departure_id,self.arrival_id])
  end

  def geometry
    GeoRuby::SimpleFeatures::LineString.from_points( [ departure.geometry, arrival.geometry], 4326) if departure.geometry and arrival.geometry
  end

  def geometry_presenter
    Chouette::Geometry::ConnectionLinkPresenter.new self
  end

end

