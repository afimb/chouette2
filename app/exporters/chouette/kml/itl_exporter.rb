class Chouette::Kml::ItlExporter
  include ERB::Util
  attr_accessor :itls, :template

  def initialize(itls)
    @itls = itls
    @template = File.open('app/views/api/kml/itls/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "itls"
  end

  def file_extension
    ".kml"
  end

  def save(directory, name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if itls.present?
  end
end

