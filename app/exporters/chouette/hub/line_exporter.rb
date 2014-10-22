class Chouette::Hub::LineExporter
  include ERB::Util
  attr_accessor :line, :directory, :template
  
  def initialize(line, directory)
    @line = line
    @directory = directory
    @template = File.open('app/views/api/hub/lignes.hub.erb' ){ |f| f.read }
    @company = @line.company
    @network = @line.network
    if (line.group_of_lines.count > 0)
      @group_of_line = line.group_of_lines[0].objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
    end
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/LIGNE.TXT"
  end
  
  def self.save( lines, directory, hub_export)
    lines.each do |line|
      self.new( line, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|LINE_COUNT", :arguments => {"0" => lines.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("LIGNE\u000D\u000A") if f.size == 0
      f.write(render)
    end if line.present?
  end
end

