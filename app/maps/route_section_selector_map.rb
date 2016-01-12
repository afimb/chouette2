class RouteSectionSelectorMap < ApplicationMap

  attr_reader :route_section_selector, :style

  def initialize(route_section_selector, style = nil)
    @route_section_selector = route_section_selector
    @style = nil
  end

  def customize_map(map, page)
    layer = kml_layer([route_section_selector.itinerary.referential, route_section_selector.itinerary.route.line, route_section_selector.itinerary.route, route_section_selector.itinerary],
                      { rendererOptions: { zIndexing: true }, styleMap: Design::JourneyPatternStyleMap.new(helpers).style_map })
    page.assign 'journeyPatternLayer', layer

    page << map.add_layer(:journeyPatternLayer)
    page << map.add_control(hover_control_display_name(:journeyPatternLayer))

    route_section_geometry = OpenLayers::Layer::Vector.new('Route Section Geometry',
                                                           { projection: projection('EPSG:900913'),
                                                             rendererOptions: { zIndexing: true },
                                                             styleMap: Design::RouteSectionSelectorStyleMap.new(helpers).style_map})

    route_section_layer_points = []
    route_section_selector.sections.reject{|s| s.candidates.length==0}.each do |section|
      section.candidates.each do |candidate|
        geometry = candidate.processed_geometry
        route_section_layer_points << ["#{candidate.id}"] + clean_route_section_line(geometry)
      end
    end

    page.assign :route_section_layer_points, route_section_layer_points
    page << <<EOF
      var route_section_layers;
      route_section_layers = route_section_layer_points.map(function(elt, index) {
        var route_section_id = elt[0];
        elt.splice(0, 1);
        var points = elt.map( function(e,i) {
          return OpenLayers.Projection.transform(new OpenLayers.Geometry.Point(e[0], e[1]), "EPSG:4326", "EPSG:900913" );
          })
        return new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString(points), {id: route_section_id, name: ""});
      })
EOF
    page.assign :route_section_geometry, route_section_geometry
    page << 'route_section_geometry.addFeatures(route_section_layers)'
    page << map.add_layer(:route_section_geometry)

    page << <<EOF
    function selected(feature) {
      RouteSectionMap.onSelectedFeature(feature);
    }
    function unselected(feature) {
      RouteSectionMap.onUnselectedFeature(feature);
    }

    highlightControl = new OpenLayers.Control.SelectFeature([route_section_geometry],
      {
        clickout: true,
        toggle: false,
        multiple:false,
        hover:true,
        highlightOnly:true,
        eventListeners:{
          featurehighlighted: function (event) {
            event.feature.layer.drawFeature(
              event.feature,
              'highlight'
            );
          },
          featureunhighlighted: function (event) {
            event.feature.layer.drawFeature(
              event.feature,
                'default'
            );
          }
        }
      }
    );
    selectControl = new OpenLayers.Control.SelectFeature([route_section_geometry],
      {
        onSelect:selected,
        onUnselect:unselected
      }
    );
    map.addControl(highlightControl);
    map.addControl(selectControl);
    highlightControl.activate();
    selectControl.activate();
EOF

    #page.assign :select_feature, OpenLayers::Control::SelectFeature.new(:route_section_geometry, {onSelect: selected, onUnselect: unselected})
    #page << map.add_control( :select_feature )


    page << map.zoom_to_extent(bounds.to_google.to_openlayers) if bounds

  end

  def clean_route_section_line(line)
    point_array = line.to_s.scan(/-?\d+[.]\d+\s-?\d+[.]\d+/)
    point_array.map do |point|
      point = point.scan(/-?\d+[.]\d+/)
      lat = point[0].to_f
      lng = point[1].to_f
      [lat, lng]
    end

  end

  def ready?
     bounds.present?
   end

   def bounds
     @bounds ||= GeoRuby::SimpleFeatures::Point.bounds(route_section_selector.itinerary.route.stop_areas.collect(&:geometry).compact)
   end
end
