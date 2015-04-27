jQuery ->
  
  get_export_results = (html_container, html_element) ->
    html_container.children().each ->
      if( $( this ).is(html_element) )
        $( this ).show()
      else
        $( this ).hide()

  Morris.Donut({
    element: 'files_statistics',
    data: [
      {label: "<%= t 'exports.show.graph.files.error' %>", value: <%= @export.report.error_files.count %> },
      {label: "<%= t 'exports.show.graph.files.ignored' %>", value: <%= @export.report.ignored_files.count %> },
      {label: "<%= t 'exports.show.graph.files.ok' %>", value: <%= @export.report.ok_files.count %> }
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
       switch i
         when 0 then get_export_results( $(".report"), $(".files_error"))
         when 1 then get_export_results( $(".report"), $(".files_ignored"))
         when 2 then get_export_results( $(".report"), $(".files_ok"))
         else console.log "Error no other value for donut chart")

  Morris.Bar({
    element: 'objects_statistics',
    data: [
      { object: "<%= t("exports.show.graph.lines.lines_stats").html_safe %>", value: <%= @export.report.lines %> },
      { object: "<%= t("exports.show.graph.lines.routes_stats").html_safe %>", value: <%= @export.report.routes %> },
      { object: "<%= t("exports.show.graph.lines.connection_links_stats").html_safe %>", value: <%= @export.report.connection_links %> },
      { object: "<%= t("exports.show.graph.lines.time_tables_stats").html_safe %>", value: <%= @export.report.time_tables %> },
      { object: "<%= t("exports.show.graph.lines.stop_areas_stats").html_safe %>", value: <%= @export.report.stop_areas %> },
      { object: "<%= t("exports.show.graph.lines.access_points_stats").html_safe %>", value: <%= @export.report.access_points %> },
      { object: "<%= t("exports.show.graph.lines.vehicle_journeys_stats").html_safe %>", value: <%= @export.report.vehicle_journeys %> },
      { object: "<%= t("exports.show.graph.lines.journey_patterns_stats").html_safe %>", value: <%= @export.report.journey_patterns %> }, 
    ],
    xkey: 'object',
    ykeys: ['value'],
    labels: ['<%= t "exports.show.graph.lines.objects_label" %>']
    xLabelAngle: 40,
    xAxisLabelTopPadding: 7,
    padding: 40,
    hideHover: true
  }).on('click', update = (i, row) ->
    get_export_results( $(".report"), $(".lines")) )
