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
  validates_format_of :slug, :with => %r{\A[0-9a-z_]+\Z}
  validates_format_of :prefix, :with => %r{\A[0-9a-zA-Z_]+\Z}
  validates_format_of :upper_corner, :with => %r{\A[0-9]+\.?[0-9]*\, [0-9]+\.?[0-9]*\Z}
  validates_format_of :lower_corner, :with => %r{\A[0-9]+\.?[0-9]*\, [0-9]+\.?[0-9]*\Z}

  attr_accessor :resources
  attr_accessor :upper_corner
  attr_accessor :lower_corner

  has_many :imports, :dependent => :destroy
  has_many :exports, :dependent => :destroy

  def human_attribute_name(*args)
    self.class.human_attribute_name(*args)
  end

  def lines
    Chouette::Line.scoped
  end

  def networks
    Chouette::Network.scoped
  end

  def companies
    Chouette::Company.scoped
  end

  def stop_areas
    Chouette::StopArea.scoped
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
    self.bounds ||= GeoRuby::SimpleFeatures::Envelope.from_coordinates( [ [-5.2, 42.25], [8.23, 51.1] ] ).to_polygon.as_ewkt # bounds for France by default
  end

  def switch
    raise "Referential not created" if new_record?
    Apartment::Database.switch(slug)
    self
  end

  def self.available_srids
    [
     [ "NTF Lambert Zone 1 (27561)", 27561 ],
     [ "NTF Lambert Zone 2 (27562)", 27562 ],
     [ "NTF Lambert Zone 3 (27563)", 27563 ],
     [ "NTF Lambert Zone 4 (27564)", 27564 ],
     [ "NTF Lambert 1 (27571)", 27571 ],
     [ "NTF Lambert 2 étendu (27572)", 27572 ],
     [ "NTF Lambert 3 (27573)", 27573 ],
     [ "NTF Lambert 4 (27574)", 27574 ],
     [ "RGF 93 Lambert 93 (2154)", 2154 ]
    ]
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

  before_save :update_envelope 
  before_create :update_envelope
  def update_envelope
    self.bounds = GeoRuby::SimpleFeatures::Envelope.from_coordinates([ [@lower_corner.x, @lower_corner.y], [ @upper_corner.x, @upper_corner.y ] ]).to_polygon.as_ewkt()
  end

  def upper_corner
    "#{envelope.upper_corner.x}, #{envelope.upper_corner.y}"
  end

  def upper_corner=(upper_corner)
    @upper_corner = GeoRuby::SimpleFeatures::Point.from_coordinates( upper_corner.split(",") )
  end

  def lower_corner    
    "#{envelope.lower_corner.x}, #{envelope.lower_corner.y}"
  end

  def lower_corner=(lower_corner)
    @lower_corner = GeoRuby::SimpleFeatures::Point.from_coordinates( lower_corner.split(",") )
  end

  def envelope    
    GeoRuby::SimpleFeatures::Geometry.from_ewkt(read_attribute(:bounds)).envelope
  end

end

Rails.application.config.after_initialize do
  Chouette::ActiveRecord

  class Chouette::ActiveRecord

    def referential
      @referential ||= Referential.where(:slug => Apartment::Database.current_database).first!
    end

  end
end
