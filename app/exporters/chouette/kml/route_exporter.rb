class Chouette::Kml::RouteExporter
  include ERB::Util
  attr_accessor :route, :directory, :template

  def initialize(route,directory)
    @route = route
    @directory = directory
    @template = File.open('app/views/api/kml/routes/show.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "/line_#{route.line_id}_route_#{route.id}.kml"
  end

  def self.save( routes, directory, kml_export)
    routes.each do |route|
      self.new( route, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|ROUTE_COUNT", :arguments => {"0" => routes.size})
  end

  def save
    File.open(directory + kml_name , "w+") do |f|
      f.write(render)
    end if route.present?
  end
end


