$(".export_tasks.new").ready ->
  toggle_input = (li, enabled) ->
    # Hide li block
    li.toggle(enabled)
    # Disable input/select to ignore it in POST data
    li.find("input,select").attr("disabled", !enabled)

  export_references_type_change = (event) ->
    form = $(event.target).parents('form')

    # Display the reference_ids input for the selected type
    references_type = $(event.target).val()
    for li in form.find("li.reference_ids")
      li = $(li)
      enabled = li.data("type") == references_type
      toggle_input li, enabled

    disabled_inputs = form.find("li.input").not("li.reference_ids").find("input:disabled,select:disabled")
    for disabled_input in disabled_inputs
      li = $(disabled_input).parents('li')
      toggle_input li, true

    hidden_attributes = $(event.target).find(":selected").data("hidden-attributes")
    return unless hidden_attributes

    hidden_attributes = hidden_attributes.split(',')
    for attribute in hidden_attributes
      li = form.find("##{form.attr('id')}_export_task_#{attribute}_input")
      toggle_input li, false

  $('form select[name="export_task[references_type]"]').change( export_references_type_change )
