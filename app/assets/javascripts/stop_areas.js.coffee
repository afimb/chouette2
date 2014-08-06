jQuery ->
  x_y_change = (event) -> 
    if referential_projection != undefined
      referential_point = new OpenLayers.Geometry.Point($('input#stop_area_longitude').val(), $('input#stop_area_latitude').val()).transform(new OpenLayers.Projection("EPSG:4326"), referential_projection )      
      
      $('input#stop_area_projection_x').val(referential_point.x)
      $('input#stop_area_projection_y').val(referential_point.y)
          
    feature = map.getLayersByName("stop_area")[0].getFeatureByFid($('input#stop_area_id').val())  
    google_point = new OpenLayers.LonLat($('input#stop_area_longitude').val(), $('input#stop_area_latitude').val()).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
    feature.move(google_point)
    map.setCenter(google_point, 16, false, true)      

  $('input#stop_area_longitude').change(x_y_change)
  $('input#stop_area_latitude').change(x_y_change)
   
  lon_lat_change = (event) -> 
    if referential_projection != undefined
      wgs84_point = new OpenLayers.Geometry.Point($('input#stop_area_projection_x').val(), $('input#stop_area_projection_y').val()).transform(referential_projection, new OpenLayers.Projection("EPSG:4326"))    
     
      $('input#stop_area_longitude').val( wgs84_point.x)
      $('input#stop_area_latitude').val( wgs84_point.y)

    feature = map.getLayersByName("stop_area")[0].getFeatureByFid($('input#stop_area_id').val())  
    google_point =  new OpenLayers.LonLat(wgs84_point.x, wgs84_point.y).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject())
    feature.move(google_point)
    map.setCenter(google_point, 16, false, true)      

  $('input#stop_area_projection_x').change(lon_lat_change)
  $('input#stop_area_projection_y').change(lon_lat_change)

  # Autocomplete input to choose postal code in stop_areas index
  # constructs the suggestion engine
  country_codes = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    local: $.map( JSON.parse($('#country_codes').text()), (country_code) ->  
      value: country_code
    )
  )

  country_codes.initialize()
  # kicks off the loading/processing of `local` and `prefetch`
  $('#search .typeahead').typeahead(
    {
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: 'country_codes',
      displayKey: 'value',
      source: country_codes.ttAdapter(),
    }
  )
