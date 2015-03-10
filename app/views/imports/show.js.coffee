jQuery ->
  
  get_import_results = (html_container, html_element) ->
    html_container.children().each ->
      if( $( this ).is(html_element) )
        $( this ).show()
      else
        $( this ).hide()

  Morris.Donut({
    element: 'files_statistics',
    data: [
      {label: "<%= t 'imports.show.graph.files.error' %>", value: <%= @import.report.error_files.count %> },
      {label: "<%= t 'imports.show.graph.files.ignored' %>", value: <%= @import.report.ignored_files.count %> },
      {label: "<%= t 'imports.show.graph.files.ok' %>", value: <%= @import.report.ok_files.count %> }
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
       switch i
         when 0 then get_import_results( $(".report"), $(".files_error"))
         when 1 then get_import_results( $(".report"), $(".files_ignored"))
         when 2 then get_import_results( $(".report"), $(".files_ok"))
         else console.log "Error no other value for donut chart")

  Morris.Bar({
    element: 'objects_statistics',
    data: [
      { object: "<%= t("imports.show.graph.lines.lines_stats").html_safe %>", value: <%= @import.report.lines %> },
      { object: "<%= t("imports.show.graph.lines.routes_stats").html_safe %>", value: <%= @import.report.routes %> },
      { object: "<%= t("imports.show.graph.lines.connection_links_stats").html_safe %>", value: <%= @import.report.connection_links %> },
      { object: "<%= t("imports.show.graph.lines.time_tables_stats").html_safe %>", value: <%= @import.report.time_tables %> },
      { object: "<%= t("imports.show.graph.lines.stop_areas_stats").html_safe %>", value: <%= @import.report.stop_areas %> },
      { object: "<%= t("imports.show.graph.lines.access_points_stats").html_safe %>", value: <%= @import.report.access_points %> },
      { object: "<%= t("imports.show.graph.lines.vehicle_journeys_stats").html_safe %>", value: <%= @import.report.vehicle_journeys %> },
      { object: "<%= t("imports.show.graph.lines.journey_patterns_stats").html_safe %>", value: <%= @import.report.journey_patterns %> }, 
    ],
    xkey: 'object',
    ykeys: ['value'],
    labels: ['<%= t "imports.show.graph.lines.objects_label" %>']
    xLabelAngle: 40,
    xAxisLabelTopPadding: 7,
    padding: 40,
    hideHover: true
  }).on('click', update = (i, row) ->
       get_import_results( $(".report"), $(".lines")) )