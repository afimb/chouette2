class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug
  validates_presence_of :prefix
  validates_presence_of :time_zone
  validates_uniqueness_of :slug
  validates_uniqueness_of :name
  validates_format_of :slug, :with => %r{\A[0-9a-z_]+\Z}
  validates_format_of :prefix, :with => %r{\A[0-9a-zA-Z_]+\Z}

  has_many :imports, :dependent => :destroy
  has_many :exports, :dependent => :destroy

  after_initialize :init_time_zone
  
  def init_time_zone
    if time_zone.nil?
      self.time_zone = "Paris"
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

  def switch
    raise "Referential not created" if new_record?
    Apartment::Database.switch(slug)
    self
  end

  before_create :create_schema
  before_destroy :destroy_schema

  after_create :import_resources

  attr_accessor :resources

  def import_resources
    imports.create(:resources => resources) if resources
  end

  def create_schema
    Apartment::Database.create slug
  end

  def destroy_schema
    Apartment::Database.drop slug
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
