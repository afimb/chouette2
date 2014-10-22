class Chouette::Hub::JourneyPatternExporter
  include ERB::Util
  attr_accessor :journey_pattern, :directory, :template
  
  def initialize(journey_pattern, directory)
    @journey_pattern = journey_pattern
    @directory = directory
    @template = File.open('app/views/api/hub/chemins.hub.erb' ){ |f| f.read }
    @type = "COM"
    if @journey_pattern.route
      if @journey_pattern.route.line_id
        @line = Chouette::Line.find(@journey_pattern.route.line_id)
      end
    end
    @stop_areas = []
    if @journey_pattern.stop_points
      @stop_points = @journey_pattern.stop_points.order(:position)
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
    "/CHEMIN.TXT"
  end
  
  def self.save( journey_patterns, directory, hub_export)
    journey_patterns.each do |journey_pattern|
      self.new( journey_pattern, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|JOURNEY_PATTERN_COUNT", :arguments => {"0" => journey_patterns.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("CHEMIN\u000D\u000A") if f.size == 0
      f.write(render)
    end if journey_pattern.present?
  end
end

