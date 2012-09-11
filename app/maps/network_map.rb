class NetworkMap < ApplicationMap

  attr_reader :network, :network_style

  def initialize(network, network_style = nil)
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
      
      page.assign "stop_areas_layer", kml_layer([network.referential, network], :styleMap => StyleMap::StopAreasStyleMap.new.style_map)

      page << map.add_layer(:stop_areas_layer)
      page << map.add_control( hover_control_display_name(:stop_areas_layer) )

      #page << map.add_layer(kml_layer(network, :styleMap => StyleMap::NetworkStyleMap.new( :style => network_style).style_map))
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(network.stop_areas.collect(&:geometry).compact)
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

end
