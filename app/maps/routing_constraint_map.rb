class RoutingConstraintMap < ApplicationMap

  attr_reader :stop_areas

  def initialize(stop_areas)
    @stop_areas = stop_areas
  end

  def customize_map(map, page)
    @stop_areas.each do |stop_area|
      if stop_area.parents.present?
        page.assign "parents_layer", kml_layer(stop_area, { :parents => true }, :style_map => Design::StopAreasStyleMap.new(helpers).style_map)
        page << map.add_layer(:parents_layer)
        page << map.add_control( hover_control_display_name(:parents_layer) )
      end
      if stop_area.children.present?
        page.assign "children_layer", kml_layer(stop_area, { :children => true }, :style_map => Design::StopAreasStyleMap.new(helpers).style_map)
        page << map.add_layer(:children_layer)
        page << map.add_control( hover_control_display_name(:children_layer) )
      end

      page.assign "edit_stop_area_layer", kml_layer(stop_area, { :default => false }, :style_map => Design::EditStopAreaStyleMap.new(helpers).style_map)

      page << <<EOF
        var createAddressStyleMap = function() {
          var defProp = {fill: false, stroke: false, label: "\uf041", labelAlign: "cb", labelXOffset: 0, labelYOffset: 0, fontSize:"20px", fontOpacity: 1, fontFamily: "FontAwesome", labelOutlineWidth: 2};
          var defStyle = OpenLayers.Util.applyDefaults(defProp, OpenLayers.Feature.Vector.style["default"]);
          return new OpenLayers.StyleMap({'default': defStyle, });
        };
        var address_layer = new OpenLayers.Layer.Vector( "address_layer", {styleMap: createAddressStyleMap()});

        var removeAddress = function() {
          address_layer.destroyFeatures();
        };

        var addAddress = function( lat, lng, name ) {
          var wgs84point = new OpenLayers.Geometry.Point( lat, lng);
          var point = transformedGeometry( wgs84point, "EPSG:4326", "EPSG:900913" )
          var feature = new OpenLayers.Feature.Vector( point, { name: name});
          address_layer.addFeatures( [feature]);

          var bounds = new OpenLayers.Bounds();
          bounds.extend( feature.geometry.getBounds());
          for (var x in edit_stop_area_layer.features) {
              bounds.extend( edit_stop_area_layer.features[x].geometry.getBounds());
          }
          map.zoomToExtent(bounds.scale(2), true);
        };
        var transformedGeometry = function( geometry, origin, target ) {
          return geometry.clone().transform( new OpenLayers.Projection( origin ), new OpenLayers.Projection( target ));
        }
EOF
      page << map.add_layer(:address_layer)
      page << map.add_layer(:edit_stop_area_layer)
      page << map.set_center(center.to_google.to_openlayers, 16, false, true)
      page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
    end
  end

  def ready?
    center.present?
  end

  def center
    @stop_areas.first.geometry or @stop_areas.first.default_position
  end

  def bounds
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(@stop_areas.collect(&:geometry).compact)
  end

end
