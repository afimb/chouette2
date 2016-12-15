require 'geokit'
require 'geo_ruby'

class Chouette::AccessPoint < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"
  include Geokit::Mappable
  include ProjectionFields

  has_many :access_links, :dependent => :destroy
  belongs_to :stop_area
  
  attr_accessor :access_point_type
  attr_writer :coordinates
  
  validates_presence_of :name
  validates_presence_of :access_type

  validates_presence_of :latitude, :if => :longitude
  validates_presence_of :longitude, :if => :latitude
  validates_numericality_of :latitude, :less_than_or_equal_to => 90, :greater_than_or_equal_to => -90, :allow_nil => true
  validates_numericality_of :longitude, :less_than_or_equal_to => 180, :greater_than_or_equal_to => -180, :allow_nil => true

  validates_format_of :coordinates, :with => %r{\A *-?(0?[0-9](\.[0-9]*)?|[0-8][0-9](\.[0-9]*)?|90(\.[0]*)?) *\, *-?(0?[0-9]?[0-9](\.[0-9]*)?|1[0-7][0-9](\.[0-9]*)?|180(\.[0]*)?) *\Z}, :allow_nil => true, :allow_blank => true

  def self.nullable_attributes
    [:street_name, :country_code, :comment, :long_lat_type, :zip_code, :city_name]
  end

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
    stop_area.geometry or stop_area.default_position
  end


  def access_point_type
    access_type && Chouette::AccessPointType.new(access_type.underscore)
  end

  def access_point_type=(access_point_type)   
    self.access_type = (access_point_type ? access_point_type.camelcase : nil)
  end

  @@access_point_types = nil
  def self.access_point_types
    @@access_point_types ||= Chouette::AccessPointType.all.select do |access_point_type|
      access_point_type.to_i >= 0
    end
  end

  def generic_access_link_matrix
     matrix = Array.new
     hash = Hash.new
     access_links.each do |link|
        hash[link.link_key] = link
     end
     key=Chouette::AccessLink.build_link_key(self,stop_area,"access_point_to_stop_area")
     if hash.has_key?(key)
       matrix << hash[key]
     else
       link = Chouette::AccessLink.new
       link.access_point = self
       link.stop_area = stop_area
       link.link_orientation_type = "access_point_to_stop_area"
       matrix << link
     end
     key=Chouette::AccessLink.build_link_key(self,stop_area,"stop_area_to_access_point")
     if hash.has_key?(key)
       matrix << hash[key]
     else
       link = Chouette::AccessLink.new
       link.access_point = self
       link.stop_area = stop_area
       link.link_orientation_type = "stop_area_to_access_point"
       matrix << link
     end
     matrix
  end

  def detail_access_link_matrix
     matrix = Array.new
     hash = Hash.new
     access_links.each do |link|
        hash[link.link_key] = link
     end
     stop_area.children_at_base.each do |child|
       key=Chouette::AccessLink.build_link_key(self,child,"access_point_to_stop_area")
       if hash.has_key?(key)
         matrix << hash[key]
       else
         link = Chouette::AccessLink.new
         link.access_point = self
         link.stop_area = child
         link.link_orientation_type = "access_point_to_stop_area"
         matrix << link
       end
       key=Chouette::AccessLink.build_link_key(self,child,"stop_area_to_access_point")
       if hash.has_key?(key)
         matrix << hash[key]
       else
         link = Chouette::AccessLink.new
         link.access_point = self
         link.stop_area = child
         link.link_orientation_type = "stop_area_to_access_point"
         matrix << link
       end
     end
     matrix
  end

  def geometry_presenter
    Chouette::Geometry::AccessPointPresenter.new self
  end
end
