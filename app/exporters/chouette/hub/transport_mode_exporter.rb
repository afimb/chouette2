class Chouette::Hub::TransportModeExporter
  include ERB::Util
  attr_accessor :transport_mode, :transport_lines, :directory, :template
  
  def initialize(transport_mode, transport_lines, directory)
    @transport_mode = transport_mode
    @transport_lines = transport_lines
    @directory = directory
    @template = File.open('app/views/api/hub/modes_transports.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/MODETRANSPORT.TXT"
  end
  
  def self.save( transport_modes, directory, hub_export)
    transport_modes.keys.sort.each do |key|
      self.new( key, transport_modes[key], directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|TRANSPORT_MODE_COUNT", :arguments => {"0" => transport_modes.keys.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("MODETRANSPORT\u000D\u000A") if f.size == 0
      f.write(render)
    end
  end
end
