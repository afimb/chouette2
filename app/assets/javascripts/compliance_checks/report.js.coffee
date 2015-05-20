$(".compliance_checks.report, .imports.compliance_check").ready ->

  get_compliance_check_results = (html_container, css_class) ->
    html_container.each ->
      if( $( this ).hasClass(css_class) )
        $( this ).show()
      else
        $( this ).hide()

  Morris.Donut({
    element: 'error',
    data: [
      { label: $(".table").data('title-nok'), value: $("tr.nok_error").size() },
      { label: $(".table").data('title-uncheck'), value: $("tr.uncheck_error").size() },
      { label: $(".table").data('title-ok'), value: $("tr.ok_error").size() }
    ],
    colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report tbody tr"), "nok_error")
      when 1 then get_compliance_check_results( $(".report tbody tr"), "uncheck_error")
      when 2 then get_compliance_check_results( $(".report tbody tr"), "ok_error") )

  Morris.Donut({
    element: 'warning',
    data: [
      { label: $(".table").data('title-nok'), value: $("tr.nok_warning").size() },
      { label: $(".table").data('title-uncheck'), value: $("tr.uncheck_warning").size() },
      { label: $(".table").data('title-ok'), value: $("tr.ok_warning").size() }
    ],
    colors: [ "#ffbd2b", "#898e7f", "#8fc861" ]
  }).on('click', update = (i, row) ->
    switch i
      when 0 then get_compliance_check_results( $(".report tbody tr"), "nok_warning")
      when 1 then get_compliance_check_results( $(".report tbody tr"), "uncheck_warning")
      when 2 then get_compliance_check_results( $(".report tbody tr"), "ok_warning") )

  $(".notice").popover({ container: "body", html: false, trigger: "focus", placement: "bottom" })
  # Hide and show error details
  $(".title_error").each ->
    $( this ).click ->
      $(this).next(".details_error").toggle()
      $(this).children("i").toggleClass("fa-plus-square fa-minus-square")

  refreshInterval = $(".report").data("refresh-interval")
  if refreshInterval > 0
    reloadPage = () -> window.location.reload()
    setInterval(reloadPage,refreshInterval * 1000)
