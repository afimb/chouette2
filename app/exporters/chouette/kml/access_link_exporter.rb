class Chouette::Kml::AccessLinkExporter
  include ERB::Util
  attr_accessor :access_links, :template

  def initialize(access_links)
    @access_links = access_links
    @template = File.open('app/views/api/kml/access_links/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "access_links"
  end

  def file_extension
    ".kml"
  end

  def save(directory, name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if access_links.present?
  end
end
