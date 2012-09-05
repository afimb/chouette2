jQuery ->
  swap_hour_minute = ( from, to) -> 
    rows =  $('.vehicle_journeys.edit tbody.journey_pattern_dependent_list tr')
    for row in rows 
      do (row) ->
        $(row).find( to).find('.hour')[0].value = $(row).find( from).find('.hour')[0].value
        $(row).find( to).find('.minute')[0].value = $(row).find( from).find('.minute')[0].value

  copy_departures_to_arrivals = (event) -> 
    event.preventDefault()
    swap_hour_minute( '.departure_time', '.arrival_time')

  $('.vehicle_journeys.edit a.to_arrivals').live("click", copy_departures_to_arrivals)

  copy_arrivals_to_departures = (event) -> 
    event.preventDefault()
    swap_hour_minute( '.arrival_time', '.departure_time')

  $('.vehicle_journeys.edit a.to_departures').live("click", copy_arrivals_to_departures)

