$(".compliance_check_tasks.new").ready ->
  compliance_check_task_references_type_change = (event) ->    
    references_type = $(event.target).val()

    toggle_input = (li) ->
      enabled = (li.data("type") == references_type)
      # Hide li block
      li.toggle(enabled)
      # Disable textarea to ignore it in POST data
      li.find(".token-input").attr("disabled", ! enabled)
      
    toggle_input($(li)) for li in $(event.target).parents('form').find("li.reference_ids")

  $('select[name="compliance_check_task[references_type]"]').change(compliance_check_task_references_type_change)
