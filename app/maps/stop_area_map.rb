class StopAreaMap < ApplicationMap

  attr_reader :stop_area

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(stop_area)
    @stop_area = stop_area
  end

  def customize_map(map, page)
      if stop_area.children.present?
        page.assign "children_layer", kml_layer(stop_area, { :children => true }, :style_map => Design::StopAreasStyleMap.new(helpers).style_map)
        page << map.add_layer(:children_layer)
        page << map.add_control( hover_control_display_name(:children_layer) )
      end
      if stop_area.routing_stops.present?
        page.assign "routing_layer", kml_layer(stop_area, { :routing => true }, :style_map => Design::StopAreasStyleMap.new(helpers).style_map)
        page << map.add_layer(:routing_layer)
        page << map.add_control( hover_control_display_name(:routing_layer) )
        page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds
      else


        if stop_area.new_record?
          page << <<EOF
          var createStyleMap = function() {
            var defProp = {strokeColor: "black", strokeOpacity: 1, strokeWidth: 2, fillColor: "white", fillOpacity: 1};
            var defStyle = OpenLayers.Util.applyDefaults(defProp, OpenLayers.Feature.Vector.style["default"]);
            return new OpenLayers.StyleMap({'default': defStyle});
          };
          var edit_stop_area_layer = new OpenLayers.Layer.Vector( "edit_stop_area_layer", {styleMap: createStyleMap()});

EOF
        else
          page.assign "edit_stop_area_layer", kml_layer(stop_area, { :default => editable? }, :style_map => Design::EditStopAreaStyleMap.new(helpers).style_map)
        end

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
          map.zoomToExtent(bounds,true);
        };
        var transformedGeometry = function( geometry, origin, target ) {
          return geometry.clone().transform( new OpenLayers.Projection( origin ), new OpenLayers.Projection( target ));
        }
EOF
        page << map.add_layer(:address_layer)
        page << map.add_layer(:edit_stop_area_layer)

        if editable?
          page.assign "referential_projection", projection_type.present? ? projection("EPSG:" + projection_type) : JsVar.new("undefined")

          # TODO virer ce code inline
          page << <<EOF

          var getEventWGS84 = function( event) {
            return transformedGeometry( event.geometry, "EPSG:900913", "EPSG:4326");
          }
          var getEventProjection = function( event, projCode) {
            return transformedGeometry( event.geometry, "EPSG:900913", projCode);
          }
          var updateStopAreaCoordinates = function( event ) {
            var geometry = getEventWGS84( event );
            $('#stop_area_coordinates').val( geometry.y.toString()+ ","+ geometry.x.toString());
          }
          var updateStopAreaProjectionXY = function( event, projCode ) {
            var geometry = getEventProjection( event, projCode);
            $('#stop_area_projection_xy').val( geometry.x.toString()+ ","+ geometry.y.toString());
          }

          var drawControl = new OpenLayers.Control.DrawFeature( edit_stop_area_layer, OpenLayers.Handler.Point,
              { featureAdded: function(event) {
              console.log( "featureAdded" );
                  updateStopAreaCoordinates( event);
                  if( typeof referential_projection !== 'undefined') {
                    updateStopAreaProjectionXY( event, referential_projection.projCode);
                  }
                  this.deactivate();
                }
              });

          var dragControl = new OpenLayers.Control.DragFeature( edit_stop_area_layer,
              { autoActivate: true,
                onComplete: function(event) {
                  updateStopAreaCoordinates( event);
                  if( typeof referential_projection !== 'undefined') {
                    updateStopAreaProjectionXY( event, referential_projection.projCode);
                  }
                },
              });
            map.addControl( dragControl);
            map.addControl( drawControl);
EOF

          if stop_area.new_record?
          page << <<EOF
            drawControl.activate();
EOF
          end
        end

      page << map.set_center(center.to_google.to_openlayers, 16, false, true)
      end
  end

  def projection_type
    stop_area.referential.projection_type
  end

  def ready?
    center.present?
  end

  def center
    stop_area.geometry or stop_area.default_position
  end

  def bounds
    # for ITL only
    @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(stop_area.routing_stops.collect(&:geometry).compact)
  end

end
