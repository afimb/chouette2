class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug

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

  before_create :prepare
  before_destroy :destroy_schema

  attr_accessor :resources
  attr_accessor :loader

  def loader
    @loader ||= ::Chouette::Loader.new(slug)
  end

  def prepare
    if resources
      import_resources
    else
      create_schema
    end
  end

  def with_original_filename
    Dir.mktmpdir do |tmp_dir|
      tmp_link = File.join(tmp_dir, resources.original_filename)
      FileUtils.ln_s resources.path, tmp_link
      yield tmp_link
    end
  end

  def import_resources
    # Apartment::Database.create create tables
    loader.create
    begin
      with_original_filename do |file|
        # chouette-command checks the file extension (and requires .zip) :(
        loader.import file
      end
    rescue => e
      loader.drop
      raise e
    end
  end

  def create_schema
    Apartment::Database.create slug
  end

  def destroy_schema
    Apartment::Database.drop slug
  end
  
end
