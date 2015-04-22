# -*- coding: utf-8 -*-
class Referential < ActiveRecord::Base
  include DataFormatEnumerations

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

  attr_accessor :upper_corner
  attr_accessor :lower_corner

  has_one :user
  ##has_many :rule_parameter_sets, :dependent => :destroy
  has_many :import_tasks, :dependent => :destroy
  has_many :compliance_check_tasks, :dependent => :destroy
  has_many :exports, :dependent => :destroy
  has_many :api_keys, :class_name => 'Api::V1::ApiKey', :dependent => :destroy

  belongs_to :organisation
  validates_presence_of :organisation

  #attr_accessible :data_format, :name, :prefix, :projection_type, :time_zone, :upper_corner, :lower_corner, :slug, :organisation

  def slug_excluded_values
    if ! slug.nil?
      if slug.start_with? "pg_"
        errors.add(:slug,I18n.t("referentials.errors.pg_excluded"))
      end
      if slug == 'public'
        errors.add(:slug,I18n.t("referentials.errors.public_excluded"))
      end
      if slug == self.class.connection_config[:username]
        errors.add(:slug,I18n.t("referentials.errors.user_excluded", :user => slug))
      end
    end
  end

  def viewbox_left_top_right_bottom
    [  lower_corner.lng, upper_corner.lat, upper_corner.lng, lower_corner.lat ].join(',')
  end

  def human_attribute_name(*args)
    self.class.human_attribute_name(*args)
  end

  def lines
    Chouette::Line.all
  end

  def networks
    Chouette::Network.all
  end

  def group_of_lines
    Chouette::GroupOfLine.all
  end

  def companies
    Chouette::Company.all
  end

  def stop_areas
    Chouette::StopArea.all
  end

  def access_points
    Chouette::AccessPoint.all
  end

  def access_links
    Chouette::AccessLink.all
  end

  def time_tables
    Chouette::TimeTable.all
  end

  def connection_links
    Chouette::ConnectionLink.all
  end

  def vehicle_journeys
    Chouette::VehicleJourney.all
  end

  after_initialize :define_default_attributes

  def define_default_attributes
    self.time_zone ||= Time.zone.name
  end

  def switch
    raise "Referential not created" if new_record?
    Apartment::Tenant.switch!(slug)
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
    Apartment::Tenant.create slug
  end

  before_destroy :destroy_schema
  def destroy_schema
    Apartment::Tenant.drop slug
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

  ##
  # In Development environment where cache_classes = false
  # each time a controller rb file is saved
  # ninoxe models are reloaded without after_initialize from config/initializers
  # so for development confort, it's better to keep here that after_initialize
Rails.application.config.after_initialize do

  Chouette::TridentActiveRecord

  class Chouette::TridentActiveRecord

    # add referential relationship for objectid and localization functions
    def referential
      @referential ||= Referential.where(:slug => Apartment::Tenant.current).first!
    end

    def hub_restricted?
      referential.data_format == "hub"
    end

    # override prefix for good prefix in objectid generation
    def prefix
      self.referential.prefix
    end

  end

  # Hub constraints
  Chouette::Route; class Chouette::Route; include NinoxeExtension::Hub::RouteRestrictions; end
  Chouette::JourneyPattern; class Chouette::JourneyPattern; include NinoxeExtension::Hub::JourneyPatternRestrictions; end
  Chouette::VehicleJourney; class Chouette::VehicleJourney; include NinoxeExtension::Hub::VehicleJourneyRestrictions; end
  Chouette::TimeTable; class Chouette::TimeTable; include NinoxeExtension::Hub::TimeTableRestrictions; end
  Chouette::ConnectionLink; class Chouette::ConnectionLink; include NinoxeExtension::Hub::ConnectionLinkRestrictions; end
  Chouette::StopArea; class Chouette::StopArea; include NinoxeExtension::Hub::StopAreaRestrictions; end
  Chouette::Line; class Chouette::Line; include NinoxeExtension::Hub::LineRestrictions; end
  Chouette::GroupOfLine; class Chouette::GroupOfLine; include NinoxeExtension::Hub::GroupOfLineRestrictions; end
  Chouette::Company; class Chouette::Company; include NinoxeExtension::Hub::CompanyRestrictions; end
  Chouette::Network; class Chouette::Network; include NinoxeExtension::Hub::NetworkRestrictions; end

  Chouette::TimeTable

  class Chouette::TimeTable
    def presenter
      @presenter ||= ::TimeTablePresenter.new( self)
    end
  end

  Chouette::VehicleJourney

  class Chouette::VehicleJourney
    def presenter
      @presenter ||= ::VehicleJourneyPresenter.new( self)
    end
  end

  Chouette::StopArea

  class Chouette::StopArea
    include  NinoxeExtension::ProjectionFields

    # override default_position method to add referential envelope when no stoparea is positioned
    def default_position
      # for first StopArea ... the bounds is nil , set to referential center
      Chouette::StopArea.bounds ? Chouette::StopArea.bounds.center : self.referential.envelope.center
    end


  end

  Chouette::AccessPoint

  class Chouette::AccessPoint
    include  NinoxeExtension::ProjectionFields
  end

end
end


