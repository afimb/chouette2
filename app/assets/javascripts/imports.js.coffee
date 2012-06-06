# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#import_type_submit').hide()

  import_type_change = (event) -> 
    import_type = $("select option:selected").attr("value")
    $(form).toggle($(form).is("#" + import_type + "_new")) for form in $('form.import')

  $('#import_type').change(import_type_change)
