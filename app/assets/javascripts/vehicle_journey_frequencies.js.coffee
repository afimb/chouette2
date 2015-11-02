(($) ->
  $ ->
    $('.ce-VehicleJourneyFrequencyTableBlock').dataTable
      searching: false,
      ordering: false,
      paging: false,
      scrollX: true,
      fixedColumns: true,
      bInfo: false
    window.setTimeout('$( ".dataTables_scrollBody" ).animate({scrollLeft: 100}, 500).animate({scrollLeft: 0}, 500)', 1000)
    return
  return
) jQuery
