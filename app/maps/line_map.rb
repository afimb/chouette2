
class LineMap < ApplicationMap

  attr_reader :referential, :line, :line_style

  def initialize(referential, line, line_style = nil)
    @referential = referential
    @line = line
    @line_style = line_style
  end

  def controls
    [ OpenLayers::Control::Navigation.new ]
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      #page << map.add_layer(kml_layer(line, :styleMap => StyleMap::LineStyleMap.new( :style => line_style).style_map))
      page << map.add_layer(kml_layer(polymorphic_path([referential, line, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new(true).style_map))
      page << map.zoom_to_extent(bounds) if bounds
    end
  end

  def bounds
    wgs84_bounds = Chouette::StopArea.bounds
    @bounds ||= OpenLayers::Bounds.new(wgs84_bounds.lower_corner.x, wgs84_bounds.lower_corner.y, wgs84_bounds.upper_corner.x, wgs84_bounds.upper_corner.y).transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))

  end

end
