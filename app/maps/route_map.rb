class RouteMap < ApplicationMap

  attr_reader :route, :style

  def initialize(route, style = nil)
    @route = route
    @style = style
  end

  def customize_map(map, page)
    layer = kml_layer([route.referential, route.line, route], :styleMap => StyleMap::RouteStyleMap.new.style_map)
    page.assign "routeLayer", layer
    selectFeature = OpenLayers::Control::SelectFeature.new( :routeLayer)

    page << map.add_layer( :routeLayer)
    page << map.add_control( hover_control_display_name(:routeLayer) )

    page.assign "selectFeature", selectFeature
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def ready?
    bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(route.stop_areas.collect(&:geometry).compact)
  end

end

