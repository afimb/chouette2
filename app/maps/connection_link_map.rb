
class ConnectionLinkMap < ApplicationMap

  attr_reader :connection_link, :connection_link_style

  def initialize(connection_link, connection_link_style = nil)
    @connection_link = connection_link
    @connection_link_style = connection_link_style
  end

  def customize_map(map, page)
    page.assign "stop_areas_layer", kml_layer([connection_link.referential, connection_link, :stop_areas], :styleMap => Design::StopAreasStyleMap.new(helpers).style_map) 
    page << map.add_layer(:stop_areas_layer)
    page << map.add_layer( kml_layer([connection_link.referential, connection_link], :styleMap => Design::ConnectionLinkStyleMap.new(helpers).style_map))
    page << map.add_control( hover_control_display_name(:stop_areas_layer) )
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(connection_link.stop_areas.collect(&:geometry).compact)
  end

end
