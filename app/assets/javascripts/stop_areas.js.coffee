jQuery ->
  x_y_change = (event) -> 
    if referential_projection != undefined
      projection_geometry = new OpenLayers.Geometry.Point($('input#stop_area_longitude').val(), $('input#stop_area_latitude').val()).transform(new OpenLayers.Projection("EPSG:4326"), referential_projection )
      $('input#stop_area_x').val(projection_geometry.x)
      $('input#stop_area_y').val(projection_geometry.y)
      
      #var stop_area = map.getLayersByName("stop_area")[0].getFeatureByFid(645).set
      

  $('input#stop_area_longitude').change(x_y_change)
  $('input#stop_area_latitude').change(x_y_change)
   
  lon_lat_change = (event) -> 
    if referential_projection != undefined
      projection_geometry = new OpenLayers.Geometry.Point($('input#stop_area_x').val(), $('input#stop_area_y').val()).transform(referential_projection, new OpenLayers.Projection("EPSG:4326"))
      $('input#stop_area_longitude').val(projection_geometry.x)
      $('input#stop_area_latitude').val(projection_geometry.y)

  $('input#stop_area_x').change(lon_lat_change)
  $('input#stop_area_y').change(lon_lat_change)
