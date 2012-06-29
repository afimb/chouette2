class RouteMap < ApplicationMap

  attr_reader :route, :style

  def initialize(route, style = nil)
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
      page << map.add_layer(kml_layer([route.referential, route.line, route], :styleMap => StyleMap::RouteStyleMap.new.style_map))
      page << map.zoom_to_extent(bounds) if bounds
    end
  end

  def ready?
    route_bounds.present?
  end

  def route_bounds
    @route_bound ||= (route.geometry.empty? ? Chouette::StopArea.bounds : route.geometry.envelope)
  end

  def bounds
    @bounds ||= OpenLayers::Bounds.new(
        route_bounds.lower_corner.x, route_bounds.lower_corner.y, 
        route_bounds.upper_corner.x, route_bounds.upper_corner.y).
      transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))
  end

end

