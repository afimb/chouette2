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

  disabled_action = (event) ->
    event.preventDefault()
    alert("Fonction activee au prochain milestone")

  $('#multiple_selection_menu .actions a').click(disabled_action)



