class Chouette::Kml::RouteExporter
  include ERB::Util
  attr_accessor :route, :template

  def initialize(route)
    @route = route
    @template = File.open('app/views/api/kml/routes/show.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "/line_#{route.line_id}_route_#{route.id}.kml"
  end

  def save(directory)
    File.open(directory + kml_name , "w+") do |f|
      f.write(render)
    end if route.present?
  end
end


