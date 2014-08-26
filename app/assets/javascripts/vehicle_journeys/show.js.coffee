$(".vehicle_journeys.show").ready ->
  clean_content = (event) ->
    $(event.target).find('#translate_form').contents().remove()

  $('#modal_translation').on( 'hide.bs.modal', clean_content )



