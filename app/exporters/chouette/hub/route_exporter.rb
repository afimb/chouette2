class Chouette::Hub::RouteExporter
  include ERB::Util
  attr_accessor :route, :directory, :template
  
  def initialize(route, directory)
    @route = route
    @directory = directory
    @template = File.open('app/views/api/hub/schemas.hub.erb' ){ |f| f.read }
    @line = Chouette::Line.find(@route.line_id) if @route.line_id
    @stop_areas = []
    if @route.stop_points
      @stop_points = @route.stop_points.order(:position)
      if @stop_points
        @stop_points.each { |sp| @stop_areas << Chouette::StopArea.find(sp.stop_area_id) }
      end
    end
    @stop_areas = @stop_areas.flatten
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/SCHEMA.TXT"
  end
  
  def self.save( routes, directory, hub_export)
    routes.each do |route|
      self.new( route, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|SCHEMA_COUNT", :arguments => {"0" => routes.size})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("SCHEMA\u000D\u000A") if f.size == 0
      f.write(render)
    end if route.present?
  end
end

