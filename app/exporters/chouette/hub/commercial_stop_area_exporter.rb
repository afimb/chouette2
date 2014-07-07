class Chouette::Hub::CommercialStopAreaExporter
  include ERB::Util
  attr_accessor :stop_area, :directory, :template
  
  def initialize(stop_area, directory)
    @stop_area = stop_area
    @directory = directory
    @template = File.open('app/views/api/hub/stop_area/commercial_show.hub.erb' ){ |f| f.read }
    @type = "ONNNNNNNNNNNNNNNNN"
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/ARRET.TXT"
  end
  
  def self.save( stop_areas, directory, hub_export)
    stop_areas.each do |stop_area|
      self.new( stop_area, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|COMMERCIAL_STOP_AREA_COUNT", :arguments => {"0" => stop_areas.size})
  end
  
  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("ARRET\n") if f.size == 0
      f.write(render)
    end if stop_area.present?
  end
end

