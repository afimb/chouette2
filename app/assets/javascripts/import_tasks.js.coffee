jQuery ->

  import_format_change = (event) -> 
    import_task_type = $("input:radio:checked").attr("value")
    console.log("import_task_type="+import_task_type)
    $(form).toggle($(form).is("#" + import_task_type + "_new")) for form in $('form.import_task[method = "post"]')  

  $("#import_task_format_input :radio[name='import_task[format]']").change(import_format_change)
  
  $('.import_tasks [title]').tipsy({gravity: 'w'})