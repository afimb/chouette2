class Chouette::Hub::DirectionExporter
  include ERB::Util
  attr_accessor :journey_pattern, :directory, :template
  
  def initialize(journey_pattern, directory)
    @journey_pattern = journey_pattern
    @directory = directory
    @template = File.open('app/views/api/hub/directions.hub.erb' ){ |f| f.read }
    #@arrival_stop_point = Chouette::StopPoint.find(@journey_pattern.arrival_stop_point_id) if @journey_pattern.arrival_stop_point_id
    #@direction = Chouette::StopArea.find(@arrival_stop_point.stop_area_id) if @arrival_stop_point
    route = Chouette::Route.find(@journey_pattern.route_id) if @journey_pattern.route_id
    @line = Chouette::Line.find(route.line_id) if route
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/DIRECTION.TXT"
  end
  
  def self.save( journey_patterns, directory, hub_export)
    journey_patterns.each do |journey_pattern|
      self.new( journey_pattern, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|DIRECTION_COUNT", :arguments => {"0" => journey_patterns.size})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("DIRECTION\u000D\u000A") if f.size == 0
      f.write(render)
    end if journey_pattern.present?
  end
end

