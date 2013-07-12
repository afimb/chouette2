class Chouette::Kml::LineExporter
  include ERB::Util
  attr_accessor :line, :directory, :template

  def initialize(line,directory)
    @line = line
    @directory = directory
    @template = File.open('app/views/api/kml/lines/show.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "/line_#{line.id}.kml"
  end

  def self.save( lines, directory, kml_export)
    lines.each do |line|
      self.new( line, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    kml_export.log_messages.create( :severity => "ok", :key => "EXPORT|LINE_COUNT", :arguments => {"0" => lines.size})
  end

  def save
    File.open(directory + kml_name , "w+") do |f|
      f.write(render)
    end if line.present?
  end
end

