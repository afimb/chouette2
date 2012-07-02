
class ConnectionLinkMap < ApplicationMap

  attr_reader :connection_link, :connection_link_style

  def initialize(connection_link, connection_link_style = nil)
    @connection_link = connection_link
    @connection_link_style = connection_link_style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      page.assign "stop_areas_layer", kml_layer([connection_link.referential, connection_link, :stop_areas], :styleMap => StyleMap::StopAreasStyleMap.new.style_map) 
      page << map.add_layer(:stop_areas_layer)
      page << map.add_control( hover_control_display_name(:stop_areas_layer) )
      #page << map.add_layer(kml_layer(connection_link, :styleMap => StyleMap::ConnectionLinkStyleMap.new( :style => connection_link_style).style_map))
      #page << map.add_layer(kml_layer(polymorphic_path([referential, connection_link, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new.style_map))
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(connection_link.stop_areas.collect(&:geometry).compact)
  end

end
