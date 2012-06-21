# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  export_references_type_change = (event) -> 
    references_type = $("select option:selected").attr("value")

    toggle_input = (li) ->
      enabled = (li.data("type") == references_type)
      # Hide li block
      li.toggle(enabled)
      # Disable textarea to ignore it in POST data
      li.find("textarea").attr("disabled", ! enabled)

    toggle_input($(li)) for li in $(".export_reference_ids")

  $('#export_references_type').change(export_references_type_change)
