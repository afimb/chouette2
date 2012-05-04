class RouteMap < ApplicationMap

  attr_reader :referential, :route, :style

  def initialize(referential, route, style = nil)
    @referential = referential
    @route = route
    @style = style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      #page << map.add_layer(kml_layer(line, :styleMap => StyleMap::LineStyleMap.new( :style => line_style).style_map))
      page << map.add_layer(kml_layer(polymorphic_path([referential, route.line, route], :format => :kml), :styleMap => StyleMap::RouteStyleMap.new.style_map))
      page << map.zoom_to_extent(bounds) if bounds
    end
  end

  def bounds
    wgs84_bounds = ( route.geometry.empty?) ? Chouette::StopArea.bounds : route.geometry.envelope
    
    @bounds ||= OpenLayers::Bounds.new(
        wgs84_bounds.lower_corner.x, wgs84_bounds.lower_corner.y, 
        wgs84_bounds.upper_corner.x, wgs84_bounds.upper_corner.y).
      transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))
  end

end

