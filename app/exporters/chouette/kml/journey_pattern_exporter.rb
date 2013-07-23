class Chouette::Kml::JourneyPatternExporter
  include ERB::Util
  attr_accessor :journey_pattern, :template

  def initialize(journey_pattern)
    @journey_pattern = journey_pattern
    @template = File.open('app/views/api/kml/journey_patterns/show.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "/line_#{journey_pattern.route.line_id}_route_#{journey_pattern.route.id}_journey_pattern_#{journey_pattern.id}.kml"
  end

  def self.save( journey_patterns, directory, kml_export)
    journey_patterns.each do |journey_pattern|
      self.new( journey_pattern ).tap do |specific_exporter|
        specific_exporter.save(directory)
      end
    end
    kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|JOURNEY_PATTERN_COUNT", :arguments => {"0" => journey_patterns.size})
  end

  def save(directory)
    File.open(directory + kml_name , "w+") do |f|
      f.write(render)
    end if journey_pattern.present?
  end
end

