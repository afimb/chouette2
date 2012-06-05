
class ConnectionLinkMap < ApplicationMap

  attr_reader :referential, :connection_link, :connection_link_style

  def initialize(referential, connection_link, connection_link_style = nil)
    @referential = referential
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

      page.assign "stop_areas_layer", kml_layer(polymorphic_path([referential, connection_link, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new.style_map) 
      page << map.add_layer(:stop_areas_layer)
      page << map.add_control( hover_control_display_name(:stop_areas_layer) )
      #page << map.add_layer(kml_layer(connection_link, :styleMap => StyleMap::ConnectionLinkStyleMap.new( :style => connection_link_style).style_map))
      #page << map.add_layer(kml_layer(polymorphic_path([referential, connection_link, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new.style_map))
      page << map.zoom_to_extent(bounds) if bounds
    end
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

  def bounds
    wgs84_bounds = Chouette::StopArea.bounds
    @bounds ||= OpenLayers::Bounds.new(wgs84_bounds.lower_corner.x, wgs84_bounds.lower_corner.y, wgs84_bounds.upper_corner.x, wgs84_bounds.upper_corner.y).transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))

  end

end
