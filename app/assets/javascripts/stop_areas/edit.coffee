$(".stop_areas.edit").ready ->                    

  x_y_change = (event) -> 
    c = $('input#stop_area_coordinates').val().split(",")
    if c.length == 2
      if referential_projection != undefined
        referential_point = new OpenLayers.Geometry.Point(c[1], c[0]).transform(new OpenLayers.Projection("EPSG:4326"), referential_projection )      
        
        $('input#stop_area_projection_xy').val(referential_point.x.toString()+","+referential_point.y.toString())
            
      feature = map.getLayersByName("stop_area")[0].getFeatureByFid($('input#stop_area_id').val())  
      google_point = new OpenLayers.LonLat(c[1], c[0]).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
      feature.move(google_point)
      map.setCenter(google_point, 16, false, true)      

  $('input#stop_area_coordinates').change(x_y_change)
   
  lon_lat_change = (event) -> 
    c = $('input#stop_area_projection_xy').val().split(",")
    if c.length == 2
      if referential_projection != undefined
        wgs84_point = new OpenLayers.Geometry.Point(c[0], c[1]).transform(referential_projection, new OpenLayers.Projection("EPSG:4326"))    
       
        $('input#stop_area_coordinates').val( wgs84_point.y.toString()+","+wgs84_point.x)
  
      feature = map.getLayersByName("stop_area")[0].getFeatureByFid($('input#stop_area_id').val())  
      google_point =  new OpenLayers.LonLat(wgs84_point.x, wgs84_point.y).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
      feature.move(google_point)
      map.setCenter(google_point, 16, false, true)      

  $('input#stop_area_projection_xy').change(lon_lat_change)
