class AccessPointMap < ApplicationMap

  attr_reader :access_point

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(access_point)
    @access_point = access_point
  end

  def map
    @map ||= MapLayers::Map.new(id, :projection => projection("EPSG:900913"), :controls => controls) do |map, page|
      page << map.add_layer(MapLayers::OSM_MAPNIK)
      page << map.add_layer(google_physical) 
      page << map.add_layer(google_streets) 
      page << map.add_layer(google_hybrid) 
      page << map.add_layer(google_satellite) 

      page.assign "parent_layer", kml_layer(access_point.stop_area,  :style_map => StyleMap::StopAreasStyleMap.new(helpers).style_map)
      page << map.add_layer(:parent_layer)
      page.assign "edit_access_point_layer", kml_layer(access_point, { :default => editable? }, :style_map => StyleMap::EditAccessPointStyleMap.new(helpers).style_map)
      page << map.add_layer(:edit_access_point_layer)
      
      
      if editable?
       page.assign "referential_projection", projection_type.present? ? projection("EPSG:" + projection_type) : JsVar.new("undefined")  
        # TODO virer ce code inline       
        page << <<EOF
        edit_access_point_layer.events.on({ 
                          'afterfeaturemodified': function(event) { 
                            geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
                            $('#access_point_longitude').val(geometry.x);
                            $('#access_point_latitude').val(geometry.y);

                            if(referential_projection != undefined)
                            {
                              projection_geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), referential_projection );
                              $('#access_point_projection_x').val(projection_geometry.x);
                              $('#access_point_projection_y').val(projection_geometry.y);                                                   }
                           }
                        });
EOF
        page << map.add_control(OpenLayers::Control::ModifyFeature.new(:edit_access_point_layer, :mode => 8, :autoActivate => true))

      else
        page << map.add_control( hover_control_display_name(:parent_layer) )
      end

      page << map.set_center(center.to_google.to_openlayers, 16, false, true)
    end
  end
  
  def projection_type
    access_point.referential.projection_type
  end

  def ready?
    center.present?
  end

  def center
    access_point.geometry or access_point.default_position
  end

end
