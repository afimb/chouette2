jQuery ->
  x_y_change = (event) -> 
    if referential_projection != undefined
      referential_point = new OpenLayers.Geometry.Point($('input#access_point_longitude').val(), $('input#access_point_latitude').val()).transform(new OpenLayers.Projection("EPSG:4326"), referential_projection )      
      
      $('input#access_point_x').val(referential_point.x)
      $('input#access_point_y').val(referential_point.y)
          
    feature = map.getLayersByName("access_point")[0].getFeatureByFid($('input#access_point_id').val())  
    google_point = new OpenLayers.LonLat($('input#access_point_longitude').val(), $('input#access_point_latitude').val()).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
    feature.move(google_point)
    map.setCenter(google_point, 16, false, true)      

  $('input#access_point_longitude').change(x_y_change)
  $('input#access_point_latitude').change(x_y_change)
   
  lon_lat_change = (event) -> 
    if referential_projection != undefined
      wgs84_point = new OpenLayers.Geometry.Point($('input#access_point_x').val(), $('input#access_point_y').val()).transform(referential_projection, new OpenLayers.Projection("EPSG:4326"))    
     
      $('input#access_point_longitude').val( wgs84_point.x)
      $('input#access_point_latitude').val( wgs84_point.y)

    feature = map.getLayersByName("stop_area")[0].getFeatureByFid($('input#access_point_id').val())  
    google_point =  new OpenLayers.LonLat(wgs84_point.x, wgs84_point.y).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
    feature.move(google_point)
    map.setCenter(google_point, 16, false, true)      

  $('input#access_point_x').change(lon_lat_change)
  $('input#access_point_y').change(lon_lat_change)
