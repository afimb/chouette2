
class AccessLinkMap < ApplicationMap

  attr_reader :access_link, :access_link_style

  def initialize(access_link, access_link_style = nil)
    @access_link = access_link
    @access_link_style = access_link_style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      page.assign "access_points_layer", kml_layer([access_link.referential, access_link.access_point], :styleMap => StyleMap::AccessPointsStyleMap.new(helpers).style_map) 
      page << map.add_layer(:access_points_layer)
      page.assign "stop_areas_layer", kml_layer([access_link.referential, access_link.stop_area], :styleMap => StyleMap::StopAreasStyleMap.new(helpers).style_map) 
      page << map.add_layer(:stop_areas_layer)
      page << map.add_layer( kml_layer([access_link.referential, access_link.access_point, access_link], :styleMap => StyleMap::AccessLinkStyleMap.new(helpers).style_map))
      page << map.add_control( hover_control_display_name([:access_points_layer,:stop_areas_layer]) )
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds([access_link.stop_area.geometry,access_link.access_point.geometry])
  end

end
