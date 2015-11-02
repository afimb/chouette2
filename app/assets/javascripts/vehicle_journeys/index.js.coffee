$(".vehicle_journeys.index, .vehicle_journey_frequencies.index").ready ->

  $( 'body' ).popover({html: true, trigger: "focus", selector: 'thead th button'})
  .on("show.bs.popover", (event)->
    $(event.target).data("bs.popover").tip().css("maxWidth", "350px"))

