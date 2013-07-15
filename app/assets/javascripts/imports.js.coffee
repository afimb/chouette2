jQuery ->
  $('#import_type_submit').hide()

  import_type_change = (event) -> 
    import_type = $("input:radio:checked").attr("value")
    console.log("import_type="+import_type)
    $(form).toggle($(form).is("#" + import_type + "_new")) for form in $('form.import[method = "post"]')

  $("#import_type_input :radio[name='import[type]']").change(import_type_change)
