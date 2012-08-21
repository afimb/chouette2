jQuery ->
  select_stop_on_map = (event) ->
    if (event.type == 'mouseenter') 
      if event.target.id.match(/^stop_point_(\w+)$/)
        stopAreaId = $("#"+event.target.id+" a").attr('href').match(/\d+$/)[0]
        placeMark = selectFeature.layer.getFeatureByFid( stopAreaId)
        selectFeature.unselectAll()
        selectFeature.select( placeMark)
    else
      selectFeature.unselectAll()

  $('.journey_patterns.show div.stop_points .stop_point').live("hover", select_stop_on_map)

  make_ajax_pagination = () ->
    $.get(this.href, null, null, 'script')
    false

  $('.stop_points_detail .pagination a').live("click", make_ajax_pagination)

