jQuery ->
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
