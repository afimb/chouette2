class Chouette::Hub::CityCodeExporter
  include ERB::Util
  attr_accessor :city_code, :city_name, :directory, :template
  
  def initialize(city_code, city_name, directory)
    @city_code = city_code
    @city_name = city_name
    @directory = directory
    @template = File.open('app/views/api/hub/communes.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/COMMUNES.TXT"
  end
  
  def self.save( city_codes, directory, hub_export)
    city_codes.keys.sort.each do |key|
      self.new( key, city_codes[key], directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|COMMUNE_COUNT", :arguments => {"0" => city_codes.keys.size})
  end
  
  def save
    File.open(directory + hub_name , "a:ISO_8859_1") do |f|
      f.write("COMMUNES\u000D\u000A") if f.size == 0
      f.write(render)
    end
  end
end
