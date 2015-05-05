jQuery ->
  export_references_type_change = (event) ->
    references_type = $(event.target).val()

    toggle_input = (li) ->
      enabled = (li.data("type") == references_type)
      # Hide li block
      li.toggle(enabled)
      # Disable textarea to ignore it in POST data
      console.log(enabled)  
      li.find(".token-input").first().attr("disabled", !enabled)
      console.log(li.find(".token-input"))

    toggle_input($(li)) for li in $(event.target).parents('form').find("li.reference_ids")

  $('form select[name="export_task[references_type]"]').change( export_references_type_change )
