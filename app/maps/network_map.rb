class NetworkMap < ApplicationMap

  attr_reader :network, :network_style

  def initialize(network, network_style = nil)
    @network = network
    @network_style = network_style
  end

  def customize_map(map, page)
    page.assign "stop_areas_layer", kml_layer([network.referential, network], :styleMap => StyleMap::StopAreasStyleMap.new.style_map)

    page << map.add_layer(:stop_areas_layer)
    page << map.add_control( hover_control_display_name(:stop_areas_layer) )
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(network.stop_areas.collect(&:geometry).compact)
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

end
