jQuery ->
  export_references_type_change = (event) ->
    references_type = $(event.target).val()

    toggle_input = (li) ->
      enabled = (li.data("type") == references_type)
      # Hide li block
      li.toggle(enabled)
      # Disable textarea to ignore it in POST data
      li.find("textarea").attr("disabled", ! enabled)

    toggle_input($(li)) for li in $(event.target).parents('form').find("li.export_reference_ids")

  $('select[name="export[references_type]"]').change(export_references_type_change)

  $('#export_type_submit').hide()

  export_type_change = (event) ->
    export_type = $("input:radio:checked").attr("value")
    $(form).toggle($(form).is("#" + export_type + "_new")) for form in $('form.export[method = "post"]')

  $("#export_type_input :radio[name='export[type]']").change(export_type_change)
