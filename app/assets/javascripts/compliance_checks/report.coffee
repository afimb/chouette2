$(".compliance_checks.report, .imports.compliance_check, .exports.compliance_check, #sidebar.compliance_checks_sidebar").ready ->
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

  insertSeverityDonut = (type) ->
    triggerFilter = (type,state) ->
      $("select.filter-status option[value='status-#{state}']").prop('selected', true)
      $('.table').trigger 'footable_filter', filter: "#{state}_#{type}"
    momo = Morris.Donut({
      element: type,
      data: [
        { label: $(".table").data('title-nok'), value: $("tr.nok_#{type}").length },
        { label: $(".table").data('title-uncheck'), value: $("tr.uncheck_#{type}").length },
        { label: $(".table").data('title-ok'), value: $("tr.ok_#{type}").length }
      ],
      colors: [ "#e22b1b", "#898e7f", "#8fc861" ]
    }).on('click', update = (i, row) ->
      switch i
        when 0 then triggerFilter(type,'nok')
        when 1 then triggerFilter(type,'uncheck')
        when 2 then triggerFilter(type,'ok')
    )
    $('select.filter-status').change (e)->
      switch $('select.filter-status option:selected').val()
        when 'status-nok' then momo.select(0)
        when 'status-uncheck' then momo.select(1)
        when 'status-ok' then momo.select(2)
    $("##{type}").hide()

  insertSeverityDonut('error')
  insertSeverityDonut('warning')

  $(".notice").popover({ container: "body", html: false, trigger: "focus", placement: "bottom" })
  # Hide and show error details
  $(".title_error").each ->
    $( this ).click ->
      $(this).next(".details_error").toggle()
      $(this).children("i").toggleClass("fa-plus-square fa-minus-square")

  footableFilter('table', '.filter-status')
  footableFilter('table', '.filter-severity')

  $('select.filter-severity').change (e)->
    $('.graph').hide()
    if $('select.filter-severity option:selected').val() == 'severity-warning'
      $('#warning').show()
    if $('select.filter-severity option:selected').val() == 'severity-error'
      $('#error').show()
