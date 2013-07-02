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

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
end

