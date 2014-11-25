class Chouette::Hub::PhysicalStopAreaExporter
  include ERB::Util
  attr_accessor :stop_area, :directory, :template
  
  def initialize(stop_area, directory)
    @stop_area = stop_area
    @directory = directory
    @template = File.open('app/views/api/hub/arrets_physiques.hub.erb' ){ |f| f.read }
    @type = "NNNNNNNNNNNNNNNNNN"
    if @stop_area.mobility_restricted_suitability
      @type = "NNNNNNNNNNNNNONNNN"
    end
    if @stop_area.parent_id
      @parent = Chouette::StopArea.find(@stop_area.parent_id)
    end
    @stop_area.referential.projection_type = "27562"

    wgs84 = '+proj=lonlat +datum=WGS84 +ellps=WGS84'
    @from_projection = RGeo::CoordSys::Proj4.new(wgs84)
    
    lambert2_extended = '+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs'
    @to_projection = RGeo::CoordSys::Proj4.new(lambert2_extended)
    
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
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|PHYSICAL_STOP_AREA_COUNT", :arguments => {"0" => stop_areas.size})
  end
  
  def save
    File.open(directory + hub_name , "a:ISO_8859_1") do |f|
      f.write("ARRET\u000D\u000A") if f.size == 0
      f.write(render)
    end if stop_area.present?
  end
end

