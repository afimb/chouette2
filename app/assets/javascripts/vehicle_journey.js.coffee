jQuery ->
  copy_departures_to_arrivals = (event) -> 
    event.preventDefault()
    rows =  $('.vehicle_journeys.edit tbody.journey_pattern_dependent_list tr')
    for row in rows 
      do (row) ->
        arrival = row.children[0]
        departure = row.children[2]
        arrival.children[0].value = departure.children[0].value
        arrival.children[1].value = departure.children[1].value

  $('.vehicle_journeys.edit a.to_arrivals').click(copy_departures_to_arrivals)

  copy_arrivals_to_departures = (event) -> 
    event.preventDefault()
    rows =  $('.vehicle_journeys.edit tbody.journey_pattern_dependent_list tr')
    for row in rows 
      do (row) ->
        arrival = row.children[0]
        departure = row.children[2]
        departure.children[0].value = arrival.children[0].value
        departure.children[1].value = arrival.children[1].value

  $('.vehicle_journeys.edit a.to_departures').click(copy_arrivals_to_departures)

