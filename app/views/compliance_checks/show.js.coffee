jQuery ->

  get_compliance_check_results = (html_container, status, severity) ->
    h = new Object()
    h["status"] = status if status
    h["severity"] = severity if severity    
      
    $.get(
        "<%= @compliance_check.id %>/compliance_check_results",
        h,
        update = (data) ->
          html_container.empty()
          html_container.append(data)
    )

  Morris.Donut({
    element: 'error',
    data: [
      {label: "<%= t 'nok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.nok_error.count %>},
      {label: "<%= t 'na', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.na_error.count %>},
      {label: "<%= t 'ok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.ok_error.count %>}
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report"), "NOK", "ERROR")
      when 1 then get_compliance_check_results( $(".report"), "UNCHECK", "ERROR")
      when 2 then get_compliance_check_results( $(".report"), "OK", "ERROR")
      else console.log "Error no other value for donut chart")

  Morris.Donut({
    element: 'warning',
    data: [
      {label: "<%= t 'nok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.nok_warning.count %>},
      {label: "<%= t 'na', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.na_warning.count %>},
      {label: "<%= t 'ok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check.compliance_check_validation_report.ok_warning.count %>}
    ]
    colors: [ "#ffbd2b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report"), "NOK", "WARNING")
      when 1 then get_compliance_check_results( $(".report"), "UNCHECK", "WARNING")
      when 2 then get_compliance_check_results( $(".report"), "OK", "WARNING")
      else console.log "Error no other value for donut chart")

  $(".resume .col1 .caption").click ->
    get_compliance_check_results( $(".report"), null, "ERROR")

  $(".resume .col2 .caption").click ->
    get_compliance_check_results( $(".report"), null, "WARNING")

                                      
