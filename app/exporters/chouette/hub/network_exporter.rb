class Chouette::Hub::NetworkExporter
  include ERB::Util
  attr_accessor :network, :directory, :template
  
  def initialize(network, directory)
    @network = network
    @directory = directory
    @template = File.open('app/views/api/hub/reseaux.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/RESEAU.TXT"
  end
  
  def self.save( networks, directory, hub_export)
    networks.each do |network|
      self.new( network, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|NETWORK_COUNT", :arguments => {"0" => networks.size})
  end
  
  def save
    File.open(directory + hub_name , "a:ISO_8859_1") do |f|
      f.write("RESEAU\u000D\u000A") if f.size == 0
      f.write(render)
    end if network.present?
  end
end

