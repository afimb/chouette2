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
      {label: "<%= t 'import_tasks.show.graph.files.error' %>", value: <%= @files_stats["error_count"] %> },
      {label: "<%= t 'import_tasks.show.graph.files.ignored' %>", value: <%= @files_stats["ignored_count"] %> },
      {label: "<%= t 'import_tasks.show.graph.files.ok' %>", value: <%= @files_stats["ok_count"] %> }
    ]
    colors: [ "#e22b1b", "#ffbd2b", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_import_results( $(".report"), $(".files_error"))
      when 1 then get_import_results( $(".report"), $(".files_ignored"))
      when 2 then get_import_results( $(".report"), $(".files_ok"))
      else console.log "Error no other value for donut chart")

  Morris.Bar({
    element: 'objects_statistics',
    data: [
      { object: "<%= t("import_tasks.show.graph.lines.lines_stats") %>", value: <%= @lines_stats["line_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.routes_stats") %>", value: <%= @lines_stats["route_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.connection_links_stats") %>", value: <%= @lines_stats["connection_link_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.time_tables_stats") %>", value: <%= @lines_stats["time_table_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.stop_areas_stats") %>", value: <%= @lines_stats["stop_area_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.access_points_stats") %>", value: <%= @lines_stats["access_point_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.vehicle_journeys_stats") %>", value: <%= @lines_stats["vehicle_journey_count"] %> },
      { object: "<%= t("import_tasks.show.graph.lines.journey_patterns_stats") %>", value: <%= @lines_stats["journey_pattern_count"] %> }, 
    ],
    xkey: 'object',
    ykeys: ['value'],
    labels: ['<%= t "import_tasks.show.graph.lines.objects_label" %>']
  }).on('click', update = (i, row) ->
    get_import_results( $(".report"), $(".lines")) )