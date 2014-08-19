jQuery ->
  swap_hour_minute = ( from, to) ->
    rows =  $('.vehicle_journeys tbody.journey_pattern_dependent_list tr.time')
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

  convert = (val) ->
    if (val < 10)
      return "0" + val.toString()
    else
      return val.toString()

  slide_to = ( col, duration) ->
    rows =  $('.vehicle_journeys tbody.journey_pattern_dependent_list .time')
    for row in rows
      do (row) ->

        oldHour = parseInt( $( $(row).find( col).find('.hour')).val())
        oldMinute = parseInt( $( $(row).find( col).find('.minute')).val())
        aTime = (((oldHour - 1) * 60) + oldMinute + duration) * 60000
        newValue = new Date(aTime)
        $( $(row).find( col).find('select.hour')).prop( "selectedIndex", convert(newValue.getHours()))
        $( $(row).find( col).find('select.minute')).prop( "selectedIndex", convert(newValue.getMinutes()))

  slide = (event) ->
    event.preventDefault()
    hour = parseInt( $(".vehicle_journeys .date select#date_hour").val())
    minute = parseInt( $(".vehicle_journeys .date select#date_minute").val())

    selector_prefix = ".vehicle_journey_at_stops .journey_pattern_dependent_list"
    if $(this).hasClass("departure")
      vjas_hour_selector = selector_prefix + " .departure_time select.hour"
      vjas_minute_selector = selector_prefix + " .departure_time select.minute"
    else
      vjas_hour_selector = selector_prefix + " .arrival_time select.hour"
      vjas_minute_selector = selector_prefix + " .arrival_time select.minute"

    vjas_hour = $( vjas_hour_selector).prop( "selectedIndex" )
    vjas_minute = $( vjas_minute_selector).prop( "selectedIndex" )

    duration = (hour - vjas_hour) * 60 + (minute - vjas_minute)

    slide_to( '.departure_time', duration)
    slide_to( '.arrival_time', duration)

  $(document).on("click", '.vehicle_journeys a.slide', slide)
