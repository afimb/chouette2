jQuery ->
  mode_change = (event) ->
    $(".mode_specific.selected").toggle()
    $(".mode_specific.selected").toggleClass( "selected" )
    mode_selected = $("option:selected").attr("value")
    $(".mode_specific."+mode_selected).toggle()
    $(".mode_specific."+mode_selected).toggleClass( "selected" )

  $("#mode").change(mode_change)

