$(".vehicle_journey_frequencies.index").ready ->
  $( 'body' ).popover({html: true, trigger: "click", selector: '[rel="popover"]'}).on("show.bs.popover", (event)->
    $('[aria-describedby]').click()
    $(event.target).data("bs.popover").tip().css("maxWidth", "350px"))
