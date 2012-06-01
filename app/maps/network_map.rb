class NetworkMap < ApplicationMap

  attr_reader :referential, :network, :network_style

  def initialize(referential, network, network_style = nil)
    @referential = referential
    @network = network
    @network_style = network_style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      #page << map.add_layer(kml_layer(network, :styleMap => StyleMap::NetworkStyleMap.new( :style => network_style).style_map))
      page << map.add_layer(kml_layer(polymorphic_path([referential, network, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new.style_map))
      page << map.zoom_to_extent(bounds) if bounds
    end
  end

  def bounds
    wgs84_bounds = Chouette::StopArea.bounds
    @bounds ||= OpenLayers::Bounds.new(wgs84_bounds.lower_corner.x, wgs84_bounds.lower_corner.y, wgs84_bounds.upper_corner.x, wgs84_bounds.upper_corner.y).transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))

  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

end
