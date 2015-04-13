jQuery ->
  
  get_validation_results = (html_container, html_element) ->
    html_container.children().each ->
      if( $( this ).is(html_element) )
        $( this ).show()
      else
        $( this ).hide()

  Morris.Donut({
    element: 'files_statistics',
    data: [
      {label: "<%= t 'validations.show.graph.files.error' %>", value: <%= @validation.report.error_files.count %> },
      {label: "<%= t 'validations.show.graph.files.ignored' %>", value: <%= @validation.report.ignored_files.count %> },
      {label: "<%= t 'validations.show.graph.files.ok' %>", value: <%= @validation.report.ok_files.count %> }
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
       switch i
         when 0 then get_validation_results( $(".report"), $(".files_error"))
         when 1 then get_validation_results( $(".report"), $(".files_ignored"))
         when 2 then get_validation_results( $(".report"), $(".files_ok"))
         else console.log "Error no other value for donut chart")

  Morris.Bar({
    element: 'objects_statistics',
    data: [
      { object: "<%= t("validations.show.graph.lines.lines_stats").html_safe %>", value: <%= @validation.report.lines %> },
      { object: "<%= t("validations.show.graph.lines.routes_stats").html_safe %>", value: <%= @validation.report.routes %> },
      { object: "<%= t("validations.show.graph.lines.connection_links_stats").html_safe %>", value: <%= @validation.report.connection_links %> },
      { object: "<%= t("validations.show.graph.lines.time_tables_stats").html_safe %>", value: <%= @validation.report.time_tables %> },
      { object: "<%= t("validations.show.graph.lines.stop_areas_stats").html_safe %>", value: <%= @validation.report.stop_areas %> },
      { object: "<%= t("validations.show.graph.lines.access_points_stats").html_safe %>", value: <%= @validation.report.access_points %> },
      { object: "<%= t("validations.show.graph.lines.vehicle_journeys_stats").html_safe %>", value: <%= @validation.report.vehicle_journeys %> },
      { object: "<%= t("validations.show.graph.lines.journey_patterns_stats").html_safe %>", value: <%= @validation.report.journey_patterns %> }, 
    ],
    xkey: 'object',
    ykeys: ['value'],
    labels: ['<%= t "validations.show.graph.lines.objects_label" %>']
    xLabelAngle: 40,
    xAxisLabelTopPadding: 7,
    padding: 40,
    hideHover: true
  }).on('click', update = (i, row) ->
       get_validation_results( $(".report"), $(".lines")) )