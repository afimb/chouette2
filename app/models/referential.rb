class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug

  has_many :imports, :dependent => :destroy

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
