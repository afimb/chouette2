$(".vehicle_journeys.index").ready ->
  $('.vehicle_journey_popover')
    .click(-> false) # cancel click on <a> tag
    .popover({ html : true })
    .on("show.bs.popover", ->
      $(this).data("bs.popover").tip().css(maxWidth: "350px"))


  # $(".breadcrumb li a").last()
  #   .click(-> false) # cancel click on <a> tag
  #   .popover({
  #       html : true,
  #       container: 'body',
  #       placement: 'bottom',
  #       content: route_popover_data_content
  #     })
