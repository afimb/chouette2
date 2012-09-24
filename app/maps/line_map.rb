
class LineMap < ApplicationMap

  attr_reader :line, :line_style

  def initialize(line, line_style = nil)
    @line = line
    @line_style = line_style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      #page << map.add_layer(kml_layer(line, :styleMap => StyleMap::LineStyleMap.new( :style => line_style).style_map))
      page.assign "stop_areas_layer", kml_layer([line.referential, line], :styleMap => StyleMap::StopAreasStyleMap.new(helpers).style_map)

      page << map.add_layer(:stop_areas_layer)
      page << map.add_control( hover_control_display_name(:stop_areas_layer) )

      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(line.stop_areas.collect(&:geometry).compact)
  end

  def ready?
    bounds.present?
  end

end
