jQuery ->

  get_validation_results = (html_container, status, severity) ->
    h = new Object()
    h["status"] = status if status
    h["severity"] = severity if severity    
      
    $.get(
        "<%= @validation.id %>/validation_results",
        h,
        update = (data) ->
          html_container.empty()
          html_container.append(data)
    )

  Morris.Donut({
    element: 'error',
    data: [
      {label: "<%= t 'nok', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.nok_error.count %>},
      {label: "<%= t 'na', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.na_error.count %>},
      {label: "<%= t 'ok', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.ok_error.count %>}
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_validation_results( $(".report"), "NOK", "ERROR")
      when 1 then get_validation_results( $(".report"), "UNCHECK", "ERROR")
      when 2 then get_validation_results( $(".report"), "OK", "ERROR")
      else console.log "Error no other value for donut chart")

  Morris.Donut({
    element: 'warning',
    data: [
      {label: "<%= t 'nok', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.nok_warning.count %>},
      {label: "<%= t 'na', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.na_warning.count %>},
      {label: "<%= t 'ok', :scope => 'validation_result.statuses' %>", value: <%= @validation.report.ok_warning.count %>}
    ]
    colors: [ "#ffbd2b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_validation_results( $(".report"), "NOK", "WARNING")
      when 1 then get_validation_results( $(".report"), "UNCHECK", "WARNING")
      when 2 then get_validation_results( $(".report"), "OK", "WARNING")
      else console.log "Error no other value for donut chart")

  $(".resume .col1 .caption").click ->
    get_validation_results( $(".report"), null, "ERROR")

  $(".resume .col2 .caption").click ->
    get_validation_results( $(".report"), null, "warning")
