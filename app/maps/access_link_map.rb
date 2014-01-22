
class AccessLinkMap < ApplicationMap

  attr_reader :access_link, :access_link_style

  def initialize(access_link, access_link_style = nil)
    @access_link = access_link
    @access_link_style = access_link_style
  end

  def customize_map(map, page)
    page.assign "access_points_layer", kml_layer([access_link.referential, access_link.access_point], :styleMap => Design::AccessPointsStyleMap.new(helpers).style_map) 
    page << map.add_layer(:access_points_layer)
    page.assign "stop_areas_layer", kml_layer([access_link.referential, access_link.stop_area], :styleMap => Design::StopAreasStyleMap.new(helpers).style_map) 
    page << map.add_layer(:stop_areas_layer)
    page << map.add_layer( kml_layer([access_link.referential, access_link.access_point, access_link], :styleMap => Design::AccessLinkStyleMap.new(helpers).style_map))
    page << map.add_control( hover_control_display_name([:access_points_layer,:stop_areas_layer]) )
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds([access_link.stop_area.geometry,access_link.access_point.geometry])
  end

end
