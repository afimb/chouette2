class Chouette::Hub::ConnectionLinkExporter
  include ERB::Util
  attr_accessor :connection_link, :directory, :template
  
  def initialize(connection_link, directory, count)
    @connection_link = connection_link
    @directory = directory
    @count = count
    @template = File.open('app/views/api/hub/correspondances.hub.erb' ){ |f| f.read }
    @departure = Chouette::StopArea.find(@connection_link.departure_id) if @connection_link.departure_id
    @arrival = Chouette::StopArea.find(@connection_link.arrival_id) if @connection_link.arrival_id
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/CORRESPONDANCE.TXT"
  end
  
  def self.save( connection_links, directory, hub_export)
    count = 1
    connection_links.each do |connection_link|
      self.new( connection_link, directory, count).tap do |specific_exporter|
        specific_exporter.save
        count += 1
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|CONNECTION_LINK_COUNT", :arguments => {"0" => connection_links.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("CORRESPONDANCE\u000D\u000A") if f.size == 0
      f.write(render) if (connection_link.present? && connection_link.link_distance.present?)
    end
  end
end

