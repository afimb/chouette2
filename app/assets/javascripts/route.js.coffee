jQuery ->
  switch_journey_patterns = (event) -> 
    event.preventDefault()
    $('.routes.show .journey_patterns.content').toggle('slow')
    $('a.journey_patterns .switcher').toggle()

  $('.routes.show a.journey_patterns').click(switch_journey_patterns)

  switch_stop_points = (event) -> 
    event.preventDefault()
    $('.routes.show .stop_points.content').toggle('slow')
    $('a.stop_points .switcher').toggle()

  $('.routes.show a.stop_points').click(switch_stop_points)

