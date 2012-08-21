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
      layer = kml_layer([route.referential, route.line, route], :styleMap => StyleMap::RouteStyleMap.new.style_map)
      page.assign "routeLayer", layer
      selectFeature = OpenLayers::Control::SelectFeature.new( :routeLayer)

      page << map.add_layer( :routeLayer)
      page << map.add_control( hover_control_display_name(:routeLayer) )
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds

      page.assign "selectFeature", selectFeature
    end
  end

  def ready?
    bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(route.stop_areas.collect(&:geometry).compact)
  end

end

