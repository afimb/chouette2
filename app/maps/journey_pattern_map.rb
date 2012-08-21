class JourneyPatternMap < ApplicationMap

  attr_reader :journey_pattern, :style

  def initialize(journey_pattern, style = nil)
    @journey_pattern = journey_pattern
    @style = style
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      #page << map.add_layer(kml_layer(line, :styleMap => StyleMap::LineStyleMap.new( :style => line_style).style_map))
      layer = kml_layer([journey_pattern.referential, journey_pattern.route.line, journey_pattern.route, journey_pattern], :styleMap => StyleMap::JourneyPatternStyleMap.new.style_map)
      page.assign "journeyPatternLayer", layer

      selectFeature = OpenLayers::Control::SelectFeature.new( :journeyPatternLayer)
      page.assign "selectFeature", selectFeature

      page << map.add_layer( :journeyPatternLayer)
      page << map.add_control( hover_control_display_name(:journeyPatternLayer) )
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def ready?
    bounds.present?
  end

  def bounds
    @bounds ||= journey_pattern.route.geometry.bounds
  end

end

