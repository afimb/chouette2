require 'geokit'
require 'geo_ruby'

class Chouette::StopArea < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"
  include Geokit::Mappable
  has_many :stop_points, :dependent => :destroy
  has_many :access_points, :dependent => :destroy
  has_many :access_links, :dependent => :destroy
  has_and_belongs_to_many :routing_lines, :class_name => 'Chouette::Line', :foreign_key => "stop_area_id", :association_foreign_key => "line_id", :join_table => "routing_constraints_lines", :order => "lines.number"
  has_and_belongs_to_many :routing_stops, :class_name => 'Chouette::StopArea', :foreign_key => "parent_id", :association_foreign_key => "child_id", :join_table => "stop_areas_stop_areas", :order => "stop_areas.name"

  acts_as_tree :foreign_key => 'parent_id',:order => "name"

  attr_accessor :stop_area_type
  attr_accessor :children_ids
  attr_writer :coordinates

  after_update :journey_patterns_control_route_sections,
               if: Proc.new { |stop_area| ['boarding_position', 'quay'].include? stop_area.stop_area_type }

  validates_format_of :registration_number, :with => %r{\A[\d\w_\-]+\Z}, :allow_blank => true
  validates_presence_of :name
  validates_presence_of :area_type

  validates_presence_of :latitude, :if => :longitude
  validates_presence_of :longitude, :if => :latitude
  validates_numericality_of :latitude, :less_than_or_equal_to => 90, :greater_than_or_equal_to => -90, :allow_nil => true
  validates_numericality_of :longitude, :less_than_or_equal_to => 180, :greater_than_or_equal_to => -180, :allow_nil => true

  validates_format_of :coordinates, :with => %r{\A *-?(0?[0-9](\.[0-9]*)?|[0-8][0-9](\.[0-9]*)?|90(\.[0]*)?) *\, *-?(0?[0-9]?[0-9](\.[0-9]*)?|1[0-7][0-9](\.[0-9]*)?|180(\.[0]*)?) *\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true

  def self.nullable_attributes
    [:registration_number, :street_name, :country_code, :fare_code,
     :nearest_topic_name, :comment, :long_lat_type, :zip_code, :city_name, :url, :time_zone]
  end

  after_update :clean_invalid_access_links

  before_save :coordinates_to_lat_lng

  def combine_lat_lng
    if self.latitude.nil? || self.longitude.nil?
      ""
    else
      self.latitude.to_s+","+self.longitude.to_s
    end
  end

  def coordinates
      @coordinates || combine_lat_lng
  end

  def coordinates_to_lat_lng
    if ! @coordinates.nil?
      if @coordinates.empty?
        self.latitude = nil
        self.longitude = nil
      else
        self.latitude = BigDecimal.new(@coordinates.split(",").first)
        self.longitude = BigDecimal.new(@coordinates.split(",").last)
      end
      @coordinates = nil
    end
  end

  def children_in_depth
    return [] if self.children.empty?

    self.children + self.children.map do |child|
      child.children_in_depth
    end.flatten.compact
  end

  def possible_children
    case area_type
      when "BoardingPosition" then []
      when "Quay" then []
      when "CommercialStopPoint" then Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition']) - [self]
      when "StopPlace" then Chouette::StopArea.where(:area_type => ['StopPlace', 'CommercialStopPoint']) - [self]
      when "ITL" then Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition', 'StopPlace', 'CommercialStopPoint'])
    end

  end

  def possible_parents
    case area_type
      when "BoardingPosition" then Chouette::StopArea.where(:area_type => "CommercialStopPoint")  - [self]
      when "Quay" then Chouette::StopArea.where(:area_type => "CommercialStopPoint") - [self]
      when "CommercialStopPoint" then Chouette::StopArea.where(:area_type => "StopPlace") - [self]
      when "StopPlace" then Chouette::StopArea.where(:area_type => "StopPlace") - [self]
    end
  end

  def geometry_presenter
    Chouette::Geometry::StopAreaPresenter.new self
  end

  def lines
    if (area_type == 'CommercialStopPoint')
      self.children.collect(&:stop_points).flatten.collect(&:route).flatten.collect(&:line).flatten.uniq
    else
      self.stop_points.collect(&:route).flatten.collect(&:line).flatten.uniq
    end
  end

  def routes
    self.stop_points.collect(&:route).flatten.uniq
  end

  def self.commercial
    where :area_type => "CommercialStopPoint"
  end

  def self.stop_place
    where :area_type => "StopPlace"
  end

  def self.physical
    where :area_type => [ "BoardingPosition", "Quay" ]
  end

  def self.itl
    where :area_type => "ITL"
  end

  def to_lat_lng
    Geokit::LatLng.new(latitude, longitude) if latitude and longitude
  end

  def geometry
    GeoRuby::SimpleFeatures::Point.from_lon_lat(longitude, latitude, 4326) if latitude and longitude
  end

  def geometry=(geometry)
    geometry = geometry.to_wgs84
    self.latitude, self.longitude, self.long_lat_type = geometry.lat, geometry.lng, "WGS84"
  end

  def position
    geometry
  end

  def position=(position)
    position = nil if String === position && position == ""
    position = Geokit::LatLng.normalize(position), 4326 if String === position
    self.latitude = position.lat
    self.longitude = position.lng
  end

  def default_position
    # for first StopArea ... the bounds is nil :(
    Chouette::StopArea.bounds and Chouette::StopArea.bounds.center
  end

  def self.near(origin, distance = 0.3)
    origin = origin.to_lat_lng

    lat_degree_units = units_per_latitude_degree(:kms)
    lng_degree_units = units_per_longitude_degree(origin.lat, :kms)

    where "SQRT(POW(#{lat_degree_units}*(#{origin.lat}-latitude),2)+POW(#{lng_degree_units}*(#{origin.lng}-longitude),2)) <= #{distance}"
  end

  def self.bounds
    # Give something like :
    # [["113.5292500000000000", "22.1127580000000000", "113.5819330000000000", "22.2157050000000000"]]
    min_and_max = connection.select_rows("select min(longitude) as min_lon, min(latitude) as min_lat, max(longitude) as max_lon, max(latitude) as max_lat from #{table_name} where latitude is not null and longitude is not null").first
    return nil unless min_and_max

    # Ignore [nil, nil, nil, nil]
    min_and_max.compact!
    return nil unless min_and_max.size == 4

    min_and_max.collect! { |n| n.to_f }

    # We need something like :
    # [[113.5292500000000000, 22.1127580000000000], [113.5819330000000000, 22.2157050000000000]]
    coordinates = min_and_max.each_slice(2).to_a
    GeoRuby::SimpleFeatures::Envelope.from_coordinates coordinates
  end

  def stop_area_type
    area_type && Chouette::AreaType.new(area_type.underscore)
  end

  def stop_area_type=(stop_area_type)
    self.area_type = (stop_area_type ? stop_area_type.camelcase : nil)
    if self.area_type == 'Itl'
      self.area_type = 'ITL'
    end
  end

  @@stop_area_types = nil
  def self.stop_area_types
    @@stop_area_types ||= Chouette::AreaType.all.select do |stop_area_type|
      stop_area_type.to_i >= 0
    end
  end

  def children_ids=(children_ids)
    children = children_ids.split(',').uniq
    # remove unset children
    self.children.each do |child|
      if (! children.include? child.id)
        child.update_attribute :parent_id, nil
      end
    end
    # add new children
    Chouette::StopArea.find(children).each do |child|
       child.update_attribute :parent_id, self.id
    end
  end

  def routing_stop_ids=(routing_stop_ids)
    stops = routing_stop_ids.split(',').uniq
    self.routing_stops.clear
    Chouette::StopArea.find(stops).each do |stop|
      self.routing_stops << stop
    end
  end

  def routing_line_ids=(routing_line_ids)
    lines = routing_line_ids.split(',').uniq
    self.routing_lines.clear
    Chouette::Line.find(lines).each do |line|
      self.routing_lines << line
    end
  end

  def self.without_geometry
    where("latitude is null or longitude is null")
  end

  def self.with_geometry
    where("latitude is not null and longitude is not null")
  end

  def self.default_geometry!
    count = 0
    where(nil).find_each do |stop_area|
      Chouette::StopArea.unscoped do
        count += 1 if stop_area.default_geometry!
      end
    end
    count
  end

  def default_geometry!
    new_geometry = default_geometry
    update_attribute :geometry, new_geometry if new_geometry
  end

  def default_geometry
    children_geometries = children.with_geometry.map(&:geometry).uniq
    GeoRuby::SimpleFeatures::Point.centroid children_geometries if children_geometries.present?
  end

  def generic_access_link_matrix
     matrix = Array.new
     access_points.each do |access_point|
       matrix += access_point.generic_access_link_matrix
     end
     matrix
  end

  def detail_access_link_matrix
     matrix = Array.new
     access_points.each do |access_point|
       matrix += access_point.detail_access_link_matrix
     end
     matrix
  end

  def children_at_base
    list = Array.new
    children_in_depth.each do |child|
      if child.area_type == 'Quay' || child.area_type == 'BoardingPosition'
        list << child
      end
    end
    list
  end

  def parents
    list = Array.new
    if !parent.nil?
      list << parent
      list += parent.parents
    end
    list
  end

  def clean_invalid_access_links
    stop_parents = parents
    access_links.each do |link|
      unless stop_parents.include? link.access_point.stop_area
        link.delete
      end
    end
    children.each do |child|
      child.clean_invalid_access_links
    end
  end

  def duplicate
    sa = self.deep_clone :except => [:object_version, :parent_id, :registration_number]
    sa.uniq_objectid
    sa.name = I18n.t("activerecord.copy", :name => self.name)
    sa
  end

  def journey_patterns_control_route_sections
    if self.changed_attributes['latitude'] || self.changed_attributes['longitude']
      self.stop_points.each do |stop_point|
        stop_point.route.journey_patterns.completed.map{ |jp| jp.control! }
      end
    end
  end

end
