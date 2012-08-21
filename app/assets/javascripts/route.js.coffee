jQuery ->
  switch_journey_patterns = (event) -> 
    event.preventDefault()
    $('.routes.show .journey_patterns.content').toggle('slow')
    $('a.journey_patterns .switcher').toggle()

  $('.routes.show a.journey_patterns').click(switch_journey_patterns)

  switch_stop_points = (event) -> 
    event.preventDefault()
    $('.routes.show .stop_points_detail').toggle('slow')
    $('a.stop_points .switcher').toggle()

  $('.routes.show a.stop_points').click(switch_stop_points)

  select_stop_on_map = (event) ->
    if (event.type == 'mouseenter') 
      if event.target.id.match(/^stop_point_(\w+)$/)
        stopAreaId = $("#"+event.target.id+" a").attr('href').match(/\d+$/)[0]
        placeMark = selectFeature.layer.getFeatureByFid( stopAreaId)
        selectFeature.unselectAll()
        selectFeature.select( placeMark)
    else
      selectFeature.unselectAll()

  $('.routes.show div.stop_points .stop_point').live("hover", select_stop_on_map)

  make_ajax_pagination = () ->
    $.get(this.href, null, null, 'script')
    false

  $('.routes.show .stop_points_detail .pagination a').live("click", make_ajax_pagination)
