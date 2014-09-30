jQuery -> 
  select_stop_on_map = (event) ->
    if (event.type == 'mouseenter') 
      if event.target.id.match(/^stop_point_(\w+)$/)
        console.log(event.target.id)
        stopAreaId = $("#"+event.target.id+" a").attr('href').match(/\d+$/)[0]
        console.log(stopAreaId) 
        placeMark = selectFeature.layer.getFeatureByFid( stopAreaId)
        selectFeature.unselectAll()
        selectFeature.select( placeMark)
    else
      selectFeature.unselectAll()

  $(document).on("hover", '.routes.show div.stop_points .stop_point', select_stop_on_map)
