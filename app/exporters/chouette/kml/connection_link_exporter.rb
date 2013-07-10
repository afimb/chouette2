class Chouette::Kml::ConnectionLinkExporter
  include ERB::Util
  attr_accessor :connection_links, :template

  def initialize(connection_links)
    @connection_links = connection_links
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

  def save(directory, name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if connection_links.present?
  end
end
