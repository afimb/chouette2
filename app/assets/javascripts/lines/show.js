$('.lines.show').ready(function() {
  // create a semi-random grid of features to be clustered
  var dx = 3;
  var dy = 3;
  var px, py;
  var markers = [];
  var epsg4326 = new OpenLayers.Projection('EPSG:4326');
  var epsg900913 = new OpenLayers.Projection('EPSG:900913');
  var strategy;
  var markersLayer;
  //var map;
  
  console.log("loading map..");
  console.log($('#refid').val());
  console.log($('#line_id').val());
  /*markers.push(new OpenLayers.Feature.Vector(
              new OpenLayers.Geometry.Point(5, 46).transform(epsg4326, epsg900913)
  ));

  markers.push(new OpenLayers.Feature.Vector(
               new OpenLayers.Geometry.Point(5, 46).transform(epsg4326, epsg900913)
  ));*/

  // set up cluster strategy and vector layer
/*  strategy = new OpenLayers.Strategy.Cluster({
    distance: 15
  });*/
  
  //markersLayer = new OpenLayers.Layer.Vector("Clustered markers", {strategies: [strategy]}); 
  
  //map = new OpenLayers.Map("map");
  //map.addLayer(new OpenLayers.Layer.OSM());
  
 /*markersLayer = new OpenLayers.Layer.Vector('Line markers', {
                    projection: map.displayProjection,
                    preFeatureInsert: function(feature) {
                      feature.geometry.transform(epsg4326,epsg900913);
                    },
                    strategies: [new OpenLayers.Strategy.Fixed(),
                                 new OpenLayers.Strategy.Cluster({
                                    distance: 15})],
                    protocol: new OpenLayers.Protocol.HTTP({
                        url: "../../"+$('#refid').val()+"/lines/"+$('#line_id').val()+".kml",
                        format: new OpenLayers.Format.KML({
                            extractStyles: true, 
                            extractAttributes: true,
                            maxDepth: 2
                        })// An empty vector layer with a refresh strategy 
var layer = new OpenLayers.Layer.Vector("POIs", {
    strategies: [new OpenLayers.Strategy.Refresh({
        interval: 1000
    })]
});
                    })
                    
                    
                });*/
  
markersLayer = map.getLayersByClass("OpenLayers.Layer.Vector");
/*for(var a = 0; a < markersLayer.length; a++ ){
    if(markersLayer[a].getVisibility()){     
        var layerName = markersLayer[a].name;
      markersLayer[a].strategies = [new OpenLayers.Strategy.Fixed(),
                                 new OpenLayers.Strategy.Cluster({
                                    distance: 50})];
markersLayer[a].redraw();
  markersLayer[a].refresh({
            force: true
        }); 
        //console.log(layerName);
        ///console.log(vlayer.name);
        /*vlayer.filter = null;
        vlayer.refresh({
            force: true
        });  
      
     // markersLayer[a].setVisibility(false);
    }
};*/
 
  
   markersLayer[1].strategies = [new OpenLayers.Strategy.Fixed(),
                                 new OpenLayers.Strategy.Cluster({
                                    distance: 50})];
markers =  markersLayer[1].features;

console.log(markersLayer[0].features.length);
markersLayer[1].redraw();
  markersLayer[1].refresh({
            force: true
        }); 
 
 /* var format = new OpenLayers.Format.GeoJSON({
  'internalProjection': new OpenLayers.Projection("EPSG:4326"),
  'externalProjection': new OpenLayers.Projection("EPSG:900913")
});
  format.write(markersLayer.features);*/
  
  //map.addLayers([new OpenLayers.Layer.OSM(), markersLayer]);
  
  //map.addLayer(markersLayer);
 // markersLayer.addFeatures(markersLayer.features);
  //map.zoomToMaxExtent();
});