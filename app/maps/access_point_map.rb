class AccessPointMap < ApplicationMap

  attr_reader :access_point

  attr_accessor :editable
  alias_method :editable?, :editable

  def initialize(access_point)
    @access_point = access_point
  end

  def customize_map(map, page)
    page.assign "edit_access_point_layer", kml_layer(access_point, { :default => editable? }, :style_map => Design::EditAccessPointStyleMap.new(helpers).style_map)
    page << map.add_layer(:edit_access_point_layer)
    page.assign "parent_layer", kml_layer(access_point.stop_area,  :style_map => Design::StopAreasStyleMap.new(helpers).style_map)
    page << map.add_layer(:parent_layer)
    
    
    if editable?
     page.assign "referential_projection", projection_type.present? ? projection("EPSG:" + projection_type) : JsVar.new("undefined")  
      # TODO virer ce code inline       
      page << <<EOF
      edit_access_point_layer.events.on({ 
                        'featuremodified': function(event) {
                          geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), new OpenLayers.Projection("EPSG:4326"));
                          $('#access_point_coordinates').val(geometry.y.toString()+ ","+ geometry.x.toString());

                          if(referential_projection != undefined)
                          {
                            projection_geometry = event.feature.geometry.clone().transform(new OpenLayers.Projection("EPSG:900913"), referential_projection );
                            $('#access_point_projection_xy').val(projection_geometry.x.toString()+ ","+ projection_geometry.y.toString());                                                   }
                         }
                      });
EOF
      page << map.add_control(OpenLayers::Control::ModifyFeature.new(:edit_access_point_layer, :mode => 8, :autoActivate => true))

    else
      page << map.add_control( hover_control_display_name(:parent_layer) )
    end

    page << map.set_center(center.to_google.to_openlayers, 16, false, true)
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
