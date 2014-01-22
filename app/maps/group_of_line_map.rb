class GroupOfLineMap < ApplicationMap

  attr_reader :group_of_line, :group_of_line_style

  def initialize(group_of_line, group_of_line_style = nil)
    @group_of_line = group_of_line
    @group_of_line_style = group_of_line_style
  end

  def customize_map(map, page)
    page.assign "stop_areas_layer", kml_layer([group_of_line.referential, group_of_line], :styleMap => Design::StopAreasStyleMap.new(helpers).style_map)

    page << map.add_layer(:stop_areas_layer)
    page << map.add_control( hover_control_display_name(:stop_areas_layer) )
    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(group_of_line.stop_areas.collect(&:geometry).compact)
  end

  def ready?
    Chouette::StopArea.bounds.present?
  end

end
