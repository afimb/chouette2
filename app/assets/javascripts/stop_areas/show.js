$('.stop_areas.show').ready(function() {
  var iw, oms, shadow, spiderfiedColor, usualColor;
  
  var map = L.map('map');
  oms = new OverlappingMarkerSpiderfier(map);
  
  var testIcon = L.icon({
    iconUrl: 'http://cdn.leafletjs.com/leaflet-0.6.2/images/marker-icon.png',
    iconSize:     [38, 95], // size of the icon
    iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
    popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
  });
  
  var marker1 = new L.Marker([46.09048081564484, 5.482091903686523], {icon: testIcon}).addTo(map);
  marker1.__name = 'marker1'
  map.addLayer(marker1);
  oms.addMarker(marker1);

  var marker2 = new L.Marker([46.09048081564484, 5.482091903686523], {icon: testIcon}).addTo(map);
  marker2.__name = 'marker2'
  map.addLayer(marker2);
  oms.addMarker(marker2);
});
      
    
   

     
      
        
     