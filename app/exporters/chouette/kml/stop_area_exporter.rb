class Chouette::Kml::StopAreaExporter
  include ERB::Util
  attr_accessor :stop_areas, :directory, :template

  def initialize(stop_areas,directory)
    @stop_areas = stop_areas
    @directory = directory
    @template = File.open('app/views/api/kml/stop_areas/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "stop_areas"
  end

  def file_extension
    ".kml"
  end

  def save( name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if stop_areas.present?
  end
end

