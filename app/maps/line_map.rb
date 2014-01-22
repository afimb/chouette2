
class LineMap < ApplicationMap

  attr_reader :line, :line_style

  def initialize(line, line_style = nil)
    @line = line
    @line_style = line_style
  end

  def customize_map(map, page)
    page << map.add_layer(kml_layer(line, :styleMap => Design::LineStyleMap.new( :style => line_style).style_map))
    page.assign "stop_areas_layer", kml_layer([line.referential, line], :styleMap => Design::StopAreasStyleMap.new(helpers).style_map)


    page << map.add_layer(:stop_areas_layer)
    page << map.add_control( hover_control_display_name(:stop_areas_layer) )
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(line.stop_areas.collect(&:geometry).compact)
  end

  def ready?
    bounds.present?
  end

end
