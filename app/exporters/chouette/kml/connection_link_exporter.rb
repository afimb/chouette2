class Chouette::Kml::ConnectionLinkExporter
  include ERB::Util
  attr_accessor :connection_links, :directory, :template

  def initialize(connection_links,directory)
    @connection_links = connection_links
    @directory = directory
    @template = File.open('app/views/api/kml/connection_links/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "connection_links"
  end

  def file_extension
    ".kml"
  end

  def self.save( models, directory, kml_export)
    self.new( models, directory).tap do |specific_exporter|
      specific_exporter.save
    end
    kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|CONNECTION_LINK_COUNT", :arguments => {"0" => models.size})
  end

  def save( name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if connection_links.present?
  end
end
