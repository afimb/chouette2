jQuery ->
  $('#import_type_submit').hide()

  import_type_change = (event) -> 
    import_type = $("select option:selected").attr("value")
    $(form).toggle($(form).is("#" + import_type + "_new")) for form in $('form.import[method = "post"]')

  $('#import_type').change(import_type_change)
