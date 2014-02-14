jQuery ->

  get_compliance_check_results = (html_container, status, severity) ->
    h = new Object()
    h["status"] = status if status
    h["severity"] = severity if severity    
      
    $.get(
        "<%= @compliance_check_task.id %>/compliance_check_results",
        h,
        update = (data) ->
          html_container.empty()
          html_container.append(data)
    )

  Morris.Donut({
    element: 'error',
    data: [
      {label: "<%= t 'nok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.nok.error.count %>},
      {label: "<%= t 'na', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.na.error.count %>},
      {label: "<%= t 'ok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.ok.error.count %>}
    ]
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report"), "nok", "error")
      when 1 then get_compliance_check_results( $(".report"), "na", "error")
      when 2 then get_compliance_check_results( $(".report"), "ok", "error")
      else console.log "Error no other value for donut chart")

  Morris.Donut({
    element: 'warning',
    data: [
      {label: "<%= t 'nok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.nok.warning.count %>},
      {label: "<%= t 'na', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.na.warning.count %>},
      {label: "<%= t 'ok', :scope => 'compliance_check_result.statuses' %>", value: <%= @compliance_check_task.compliance_check_results.ok.warning.count %>}
    ]
    colors: [ "#ffbd2b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report"), "nok", "warning")
      when 1 then get_compliance_check_results( $(".report"), "na", "warning")
      when 2 then get_compliance_check_results( $(".report"), "ok", "warning")
      else console.log "Error no other value for donut chart")

  $(".resume .col1 .caption").click ->
    get_compliance_check_results( $(".report"), null, "error")

  $(".resume .col2 .caption").click ->
    get_compliance_check_results( $(".report"), null, "warning")

  $('img[title]').tipsy({gravity: 'w'})
  $('a[title]').tipsy({gravity: 'w'})

                                      
