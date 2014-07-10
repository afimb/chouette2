class Chouette::Hub::ConnectionLinkExporter
  include ERB::Util
  attr_accessor :connection_link, :directory, :template
  
  def initialize(connection_link, directory)
    @connection_link = connection_link
    @directory = directory
    @template = File.open('app/views/api/hub/correspondances.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/CORRESPONDANCE.TXT"
  end
  
  def self.save( connection_links, directory, hub_export)
    connection_links.each do |connection_link|
      self.new( connection_link, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|CONNECTION_LINK_COUNT", :arguments => {"0" => connection_links.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("CORRESPONDANCE\n") if f.size == 0
      f.write(render)
    end if connection_link.present?
  end
end

