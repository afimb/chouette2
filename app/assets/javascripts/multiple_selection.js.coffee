jQuery ->
  enable_multiple_selection = (event) ->
    event.preventDefault()
    $('#multiple_selection_menu div.enabled').show()
    $('#multiple_selection_menu div.disabled').hide()
    $('input[type=checkbox].multiple_selection').fadeIn()

  $('#multiple_selection_menu a.enable').click(enable_multiple_selection)

  disable_multiple_selection = (event) ->
    event.preventDefault()
    $('#multiple_selection_menu div.enabled').hide()
    $('#multiple_selection_menu div.disabled').show()
    $('input[type=checkbox].multiple_selection').fadeOut()

  $('#multiple_selection_menu a.disable').click(disable_multiple_selection)

  select_all = (event) ->
    event.preventDefault()
    $('input[type=checkbox].multiple_selection').prop("checked", true)

  $('#multiple_selection_menu a.select_all').click(select_all)

  deselect_all = (event) ->
    event.preventDefault()
    $('input[type=checkbox].multiple_selection').prop("checked", false)

  $('#multiple_selection_menu a.deselect_all').click(deselect_all)

  handle_multiple_action = (event) ->
    event.preventDefault()
    link = $(event.target)
    r = confirm( link.attr( "confirmation-text" ) );
    if (r == true)
      href = link.attr("href")
      method = link.data('multiple-method')
      csrf_token = $('meta[name=csrf-token]').attr('content')
      csrf_param = $('meta[name=csrf-param]').attr('content')
      form = $('<form method="post" action="' + href + '"></form>')
      target = link.attr('target')

      metadata_input = '<input name="_method" value="' + method + '" type="hidden" />'

      if csrf_param? and csrf_token?
        metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />'

      form.append($(input).clone()) for input in $('input[type=checkbox].multiple_selection:checked')

      form.attr('target', target) if target?

      form.hide().append(metadata_input).appendTo('body')
      form.submit()

  $('#multiple_selection_menu .actions a.remove').click(handle_multiple_action)
