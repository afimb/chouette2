jQuery ->
  swap_hour_minute = ( from, to) -> 
    rows =  $('.vehicle_journeys tbody.journey_pattern_dependent_list tr')
    for row in rows 
      do (row) ->
        $(row).find( to).find('.hour')[0].value = $(row).find( from).find('.hour')[0].value
        $(row).find( to).find('.minute')[0].value = $(row).find( from).find('.minute')[0].value

  copy_departures_to_arrivals = (event) -> 
    event.preventDefault()
    swap_hour_minute( '.departure_time', '.arrival_time')

  $(document).on("click", '.vehicle_journeys a.to_arrivals', copy_departures_to_arrivals)

  copy_arrivals_to_departures = (event) -> 
    event.preventDefault()
    swap_hour_minute( '.arrival_time', '.departure_time')

  $(document).on("click", '.vehicle_journeys a.to_departures', copy_arrivals_to_departures)

  switch_vehicle_journey_at_stops = (event) -> 
    event.preventDefault()
    $('.vehicle_journeys.show .vehicle_journey_at_stops.content').toggle('slow')
    $('a.vehicle_journey_at_stops .switcher').toggle()

  $('.vehicle_journeys.show a.vehicle_journey_at_stops').click(switch_vehicle_journey_at_stops)

  switch_time_tables = (event) -> 
    event.preventDefault()
    $('.vehicle_journeys.show .vehicle_journey_time_tables.content').toggle('slow')
    $('a.vehicle_journey_time_tables .switcher').toggle()

  $('.vehicle_journeys.show a.vehicle_journey_time_tables').click(switch_time_tables)

