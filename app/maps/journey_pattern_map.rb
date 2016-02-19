class JourneyPatternMap < ApplicationMap

  attr_reader :journey_pattern, :style

  def initialize(journey_pattern, style = nil)
    @journey_pattern = journey_pattern
    @style = style
  end

  def customize_map(map, page)
    layer = kml_layer([journey_pattern.referential, journey_pattern.route.line, journey_pattern.route, journey_pattern], { setLayerIndex: 999, styleMap: Design::JourneyPatternStyleMap.new(helpers).style_map, rendererOptions: { zIndexing: true } })
    page.assign 'journeyPatternLayer', layer
    page.assign 'selectFeature', OpenLayers::Control::SelectFeature.new(:journeyPatternLayer)

    page << map.add_layer(:journeyPatternLayer)
    page << map.add_control(hover_control_display_name(:journeyPatternLayer))
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def ready?
    bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(journey_pattern.route.stop_areas.collect(&:geometry).compact)
  end

end

