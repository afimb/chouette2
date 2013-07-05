class Chouette::Kml::LineExporter
  include ERB::Util
  attr_accessor :line, :template

  def initialize(line)
    @line = line
    @template = File.open('app/views/api/kml/lines/show.kml.erb' ){ |f| f.read }
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def kml_name
    "/line_#{line.id}.kml"
  end

  def save(directory)
    File.open(directory + kml_name , "w+") do |f|
      f.write(render)
    end if line.present?
  end
end

