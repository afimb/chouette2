class Chouette::Hub::ItlExporter
  include ERB::Util
  attr_accessor :stop_point, :stop_area_id, :stop_area_code, :line_code, :sens, :order, :type, :identifier, :directory, :template
  
  def initialize(stop_point, sens, line, directory, index)
    @stop_point = stop_point
    @directory = directory
    @template = File.open('app/views/api/hub/itls.hub.erb' ){ |f| f.read }
    @line_code = line.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2') if line
    @sens = sens == 'A' ? 1 : 2
    stop_area = stop_point.stop_area
    if stop_area
      @stop_area_code = stop_area.objectid.sub(/(\w*\:\w*\:)(\w*)/, '\2')
      @stop_area_id = stop_area.registration_number
    end
    @order = stop_point.position
    if stop_point.for_boarding == "forbidden"
      @type = 1
    elsif stop_point.for_alighting == "forbidden"
      @type = 2
    end
    @identifier = index
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/ITL.TXT"
  end
  
  def self.save( routes, directory, hub_export)
    count = 0
    routes.each do |route|
      for_boarding_stops = route.stop_points.where( :for_boarding => [ "forbidden" , "normal"] ).order(:position)
      if for_boarding_stops
        for_boarding_stops.each do |stop_point|
          count += 1
          self.new( stop_point, route.wayback, route.line, directory, count ).tap do |specific_exporter|
            specific_exporter.save
          end
        end
      end
      for_alighting_stops = route.stop_points.where( :for_alighting => [ "forbidden" , "normal"] ).order(:position)
      if for_alighting_stops
        for_alighting_stops.each do |stop_point|
          count += 1
          self.new( stop_point, route.wayback, route.line, directory, count ).tap do |specific_exporter|
            specific_exporter.save
          end
        end
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|ITL_COUNT", :arguments => {"0" => count})
  end
  
  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("ITL\u000D\u000A") if f.size == 0
      f.write(render)
    end if stop_point.present?
  end
end

