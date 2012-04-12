class StopAreaMap < ApplicationMap

  attr_reader :referential, :stop_area

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(referential, stop_area)
    @referential = referential
    @stop_area = stop_area
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)

      page.assign "edit_stop_area_layer", kml_layer( polymorphic_path( [referential, stop_area], :format => :kml, :default => editable?), :style_map => StyleMap::StopAreasStyleMap.new.style_map)
      page << map.add_layer(:edit_stop_area_layer)

#       if editable?
#         # TODO virer ce code inline
#         page << <<EOF
#         edit_stop_area_layer.events.on({ 
#                           'afterfeaturemodified': function(event) { 
#                             geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
#                             $('#potimart_stop_area_position').val(geometry.y + ',' + geometry.x);
#                            }
#                         });
# EOF
#         page << map.add_control(OpenLayers::Control::ModifyFeature.new(:edit_stop_area_layer, :mode => 8, :autoActivate => true))

#       end

      page << map.zoom_to_extent(bounds) if bounds
      #page << map.set_center(center.to_google.to_openlayers, 16, false, true)
    end
  end

  def bounds
    wgs84_bounds = Chouette::StopArea.bounds
    @bounds ||= OpenLayers::Bounds.new(wgs84_bounds.lower_corner.x, wgs84_bounds.lower_corner.y, wgs84_bounds.upper_corner.x, wgs84_bounds.upper_corner.y).transform(OpenLayers::Projection.new("EPSG:4326"), OpenLayers::Projection.new("EPSG:900913"))
  end

  def center
    stop_area.position or stop_area.default_position
  end

end
