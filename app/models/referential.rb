# -*- coding: utf-8 -*-
class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug
  validates_presence_of :prefix
  validates_presence_of :time_zone
  validates_presence_of :upper_corner
  validates_presence_of :lower_corner
  validates_uniqueness_of :slug
  validates_uniqueness_of :name
  validates_format_of :slug, :with => %r{\A[a-z][0-9a-z_]+\Z}
  validates_format_of :prefix, :with => %r{\A[0-9a-zA-Z_]+\Z}
  validates_format_of :upper_corner, :with => %r{\A-?[0-9]+\.?[0-9]*\,-?[0-9]+\.?[0-9]*\Z}
  validates_format_of :lower_corner, :with => %r{\A-?[0-9]+\.?[0-9]*\,-?[0-9]+\.?[0-9]*\Z}
  validate :slug_excluded_values
  
  attr_accessor :resources
  attr_accessor :upper_corner
  attr_accessor :lower_corner

  has_many :imports, :dependent => :destroy
  has_many :exports, :dependent => :destroy
  has_many :api_keys, :class_name => 'Api::V1::ApiKey', :dependent => :destroy
  
  belongs_to :organisation
  validates_presence_of :organisation

  def slug_excluded_values
    if ! slug.nil?
      if slug.start_with? "pg_" 
        errors.add(:slug,I18n.t("referentials.errors.pg_excluded"))
      end
      if slug == 'public'
        errors.add(:slug,I18n.t("referentials.errors.public_excluded"))
      end
    end
  end

  def human_attribute_name(*args)
    self.class.human_attribute_name(*args)
  end

  def lines
    Chouette::Line.scoped
  end

  def networks
    Chouette::Network.scoped
  end

  def group_of_lines
    Chouette::GroupOfLine.scoped
  end

  def companies
    Chouette::Company.scoped
  end

  def stop_areas
    Chouette::StopArea.scoped
  end

  def access_points
    Chouette::AccessPoint.scoped
  end

  def access_links
    Chouette::AccessLink.scoped
  end

  def time_tables
    Chouette::TimeTable.scoped
  end
  
  def connection_links
    Chouette::ConnectionLink.scoped
  end

  def vehicle_journeys
    Chouette::VehicleJourney.scoped
  end

  after_initialize :define_default_attributes

  def define_default_attributes
    self.time_zone ||= Time.zone.name
  end

  def switch
    raise "Referential not created" if new_record?
    Apartment::Database.switch(slug)
    self
  end

  def self.available_srids
    [
      [ "RGF 93 Lambert 93 (2154)", 2154 ],
      [ "RGF93 CC42 (zone 1) (3942)", 3942 ],
      [ "RGF93 CC43 (zone 2) (3943)", 3943 ],
      [ "RGF93 CC44 (zone 3) (3944)", 3944 ],
      [ "RGF93 CC45 (zone 4) (3945)", 3945 ],
      [ "RGF93 CC46 (zone 5) (3946)", 3946 ],
      [ "RGF93 CC47 (zone 6) (3947)", 3947 ],
      [ "RGF93 CC48 (zone 7) (3948)", 3948 ],
      [ "RGF93 CC49 (zone 8) (3949)", 3949 ],
      [ "RGF93 CC50 (zone 9) (3950)", 3950 ],
      [ "NTF Lambert Zone 1 Nord (27561)", 27561 ],
      [ "NTF Lambert Zone 2 Centre (27562)", 27562 ],
      [ "NTF Lambert Zone 3 Sud (27563)", 27563 ],
      [ "NTF Lambert Zone 4 Corse (27564)", 27564 ],
      [ "NTF Lambert 1 Carto (27571)", 27571 ],
      [ "NTF Lambert 2 Carto (27572)", 27572 ],
      [ "NTF Lambert 3 Carto (27573)", 27573 ],
      [ "NTF Lambert 4 Carto (27574)", 27574 ] ,
      [ "Réunion RGR92 - UTM 40S (2975)", 2975 ],
      [ "Antilles Françaises RRAF1991 - UTM 20N - IGN (4559)", 4559 ],
      [ "Guyane RGFG95 - UTM 22N (2972)", 2972 ],
      [ "Guyane RGFG95 - UTM 21N (2313)", 2313 ]
    ]
  end

  def projection_type_label 
    self.class.available_srids.each do |a|
      if a.last.to_s == projection_type
        return a.first.split('(').first.rstrip
      end
    end
    projection_type || ""
  end

  before_create :create_schema
  def create_schema
    Apartment::Database.create slug
  end

  before_destroy :destroy_schema
  def destroy_schema
    Apartment::Database.drop slug
  end

  after_create :import_resources  
  def import_resources
    imports.create(:resources => resources) if resources
  end

  def upper_corner
    envelope.upper_corner
  end

  def upper_corner=(upper_corner)
    if String === upper_corner
      upper_corner = (upper_corner.blank? ? nil : GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.normalize(upper_corner), 4326))
    end

    envelope.tap do |envelope|
      envelope.upper_corner = upper_corner
      self.bounds = envelope.to_polygon.as_ewkt
    end
  end

  def lower_corner    
    envelope.lower_corner
  end

  def lower_corner=(lower_corner)
    if String === lower_corner
      lower_corner = (lower_corner.blank? ? nil : GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.normalize(lower_corner), 4326))
    end

    envelope.tap do |envelope|
      envelope.lower_corner = lower_corner
      self.bounds = envelope.to_polygon.as_ewkt
    end
  end

  def default_bounds
    GeoRuby::SimpleFeatures::Envelope.from_coordinates( [ [-5.2, 42.25], [8.23, 51.1] ] ).to_polygon.as_ewkt
  end

  def envelope
    bounds = read_attribute(:bounds)
    GeoRuby::SimpleFeatures::Geometry.from_ewkt(bounds.present? ? bounds : default_bounds ).envelope
  end

end

Rails.application.config.after_initialize do
  
  Chouette::TridentActiveRecord

  class Chouette::TridentActiveRecord

    # add referential relationship for objectid and localization functions
    def referential
      @referential ||= Referential.where(:slug => Apartment::Database.current_database).first!
    end

    # override prefix for good prefix in objectid generation
    def prefix
      self.referential.prefix
    end

  end
  
  Chouette::StopArea
  
  class Chouette::StopArea
    
    attr_accessible :projection_x,:projection_y
    
    # override default_position method to add referential envelope when no stoparea is positioned
    def default_position 
      # for first StopArea ... the bounds is nil , set to referential center 
      Chouette::StopArea.bounds ? Chouette::StopArea.bounds.center : self.referential.envelope.center
    end
    
    # add projection_type set on pre-insert and pre_update action
    before_validation :set_projections
    def set_projections
      if ! self.latitude.nil? && ! self.longitude.nil?
        self.long_lat_type = 'WGS84'
      else
        self.long_lat_type = nil
      end
#      if ! self.referential.projection_type.nil? && !self.referential.projection_type.empty?
#        if ! self.x.nil?  && ! self.y.nil?
#          self.projection_type = referential.projection_type_label
#        else
#          self.projection_type = nil
#        end
#      else
#          self.projection_type = nil
#          self.x = nil
#          self.y = nil
#      end
    end
    
    def projection
      if self.referential.projection_type.nil? || self.referential.projection_type.empty? 
        nil
      else
        self.referential.projection_type
      end
    end
    @point = nil

    def projection_x
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        
        @point.x
      end
    end
    def projection_y
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        @point.y
      end
    end
    def projection_x=(dummy)
      # dummy method
    end
    def projection_y=(dummy)
      # dummy method
    end
 
  end

  Chouette::AccessPoint
  
  class Chouette::AccessPoint
    attr_accessible :projection_x,:projection_y

    # add projection_type set on pre-insert and pre_update action
    before_validation :set_projections
    def set_projections
      if ! self.latitude.nil? && ! self.longitude.nil?
        self.long_lat_type = 'WGS84'
      else
        self.long_lat_type = nil
      end
#      if ! self.referential.projection_type.nil? && !self.referential.projection_type.empty?
#        if ! self.x.nil?  && ! self.y.nil?
#          self.projection_type = referential.projection_type_label
#        else
#          self.projection_type = nil
#        end
#      else
#          self.projection_type = nil
#          self.x = nil
#          self.y = nil
#      end
    end
    
    def projection
      if self.referential.projection_type.nil? || self.referential.projection_type.empty? 
        nil
      else
        self.referential.projection_type
      end
    end
    @point = nil

    def projection_x
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        
        @point.x
      end
    end
    def projection_y
      if self.long_lat_type.nil? || self.projection.nil?
        nil
      else
        @point ||= GeoRuby::SimpleFeatures::Point::from_lat_lng(Geokit::LatLng.new(self.latitude,self.longitude)).project_to(self.projection.to_i)
        @point.y
      end
    end
    def projection_x=(dummy)
      # dummy method
    end
    def projection_y=(dummy)
      # dummy method
    end
  end
 
end
