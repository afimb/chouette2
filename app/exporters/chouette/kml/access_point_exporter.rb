class Chouette::Kml::AccessPointExporter
  include ERB::Util
  attr_accessor :access_points, :directory, :template

  def initialize(access_points,directory)
    @access_points = access_points
    @directory = directory
    @template = File.open('app/views/api/kml/access_points/index.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "access_points"
  end

  def file_extension
    ".kml"
  end

  def self.save( models, directory, kml_export)
    self.new( models, directory).tap do |specific_exporter|
      specific_exporter.save
    end
    kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|ACCES_POINT_COUNT", :arguments => {"0" => models.size})
  end

  def save( name = nil)
    File.open(directory + "/" + (name || kml_name) + file_extension, "w+") do |f|
      f.write(render)
    end if access_points.present?
  end
end

