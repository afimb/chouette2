jQuery ->

  import_format_change = (event) ->
    import_task_type = $("input:radio:checked").attr("value")
    $(form).toggle($(form).is("#" + import_task_type + "_new")) for form in $('form.import_task[method = "post"]')

  $("#import_task_format_input :radio[name='import_task[format]']").change(import_format_change)

  import_check_change = (event) ->
    import_task_type = $("input:radio:checked").attr("value")
    format_class = '#' + import_task_type + "_new"
    state = $(format_class + ' input[name="import_task[no_save]"]:checked') == "1"
    $(format_class + " #import_task_rule_parameter_set_id_input").toggle(  )

  $(check_input).change(import_check_change) for check_input in $('form input[name="import_task[no_save]"][type="checkbox"]')

  $('[id$="_import_task_name"]').focusout ->
    $this = $(this)
    value = $this.val()
    $('[id$="_import_task_name"]').each ->
      if $(this) != $this
        $(this).val value
      return
    return

  $('[id$="_import_task_no_save"]').click ->
    $('[id$="_import_task_no_save"]').prop 'checked', $(this).is(':checked')
    return

  $('[id$="_import_task_rule_parameter_set_id"]').focusout ->
    $this = $(this)
    value = $this.val()
    $('[id$="_import_task_rule_parameter_set_id"]').each ->
      if $(this) != $this
        $(this).val value
      return
    return
