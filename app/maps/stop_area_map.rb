class StopAreaMap < ApplicationMap

  attr_reader :stop_area

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(stop_area)
    @stop_area = stop_area
  end

  def controls
    [ OpenLayers::Control::Navigation.new ]
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)

      stop_area.lines.each do |line|
        page << map.add_layer(kml_layer(line, :styleMap => StyleMap::LineStyleMap.new({:line_color => line.color}).style_map))
        page << map.add_layer(kml_layer(polymorphic_path([line.network, line, :stop_areas], :format => :kml), :styleMap => StyleMap::StopAreasStyleMap.new(true).style_map))
      end

      styles = {"default" => {:strokeColor => "red"},
        "select" => {:strokeColor => "red",
        :strokeWidth => 4}
      }

      page.assign "edit_stop_area_layer", kml_layer( polymorphic_path( [stop_area.network, stop_area], :format => :kml, :default => editable?), :style_map => StyleMap::EditStopAreaStyleMap.new(false, false, {}, styles).style_map)
      page << map.add_layer(:edit_stop_area_layer)

      if editable?
        # TODO virer ce code inline
        page << <<EOF
        edit_stop_area_layer.events.on({ 
                          'afterfeaturemodified': function(event) { 
                            geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
                            $('#potimart_stop_area_position').val(geometry.y + ',' + geometry.x);
                           }
                        });
EOF
        page << map.add_control(OpenLayers::Control::ModifyFeature.new(:edit_stop_area_layer, :mode => 8, :autoActivate => true))

      end

      page << map.set_center(center.to_google.to_openlayers, 16, false, true)
    end
  end

  def center
    stop_area.position or stop_area.default_position
  end

end
