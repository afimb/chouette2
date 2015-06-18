$(".compliance_checks.report, .imports.compliance_check, #sidebar.compliance_checks_sidebar").ready ->

  showSeverityDonut = (severity) ->
    $("##{severity}").empty()
    console.log $("##{severity}").val()
    Morris.Donut({
      element: severity,
      data: [
        { label: $(".table").data('title-nok'), value: $("tr.nok_#{severity}").size() },
        { label: $(".table").data('title-uncheck'), value: $("tr.uncheck_#{severity}").size() },
        { label: $(".table").data('title-ok'), value: $("tr.ok_#{severity}").size() }
      ],
      colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
    }).on('click', update = (i, row) ->
      switch i
        when 0 then $('.table').trigger 'footable_filter', filter: "nok_#{severity}"
        when 1 then $('.table').trigger 'footable_filter', filter: "uncheck_#{severity}"
        when 2 then $('.table').trigger 'footable_filter', filter: "ok_#{severity}"
    )

  $('table').footable().trigger 'footable_filter', filter: 'severity-error'
  $('a.severities_warning').on 'click', (e) ->
    $('table').footable().trigger 'footable_filter', filter: 'severity-warning'

  $('a.severities_error').on 'click', (e) ->
    $('table').footable().trigger 'footable_filter', filter: 'severity-error'

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

  footableFilter = (parent, el) ->
    $(parent).footable().bind 'footable_filtering', (e) ->
      selected =  $("select#{el} option:selected").val()
      if selected and selected.length > 0
        e.filter += if e.filter and e.filter.length > 0 then ' ' + selected else selected
        e.clear = !e.filter
      return
    $("select#{el}").change (e) ->
      e.preventDefault()
      $(parent).trigger 'footable_filter', filter: $("select#{el} option:selected").val()
      return

  footableFilter('table', '.filter-status')
  footableFilter('table', '.filter-severity')
