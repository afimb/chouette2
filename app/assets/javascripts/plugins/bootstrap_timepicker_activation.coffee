jQuery ->
  if(!(Modernizr.inputtypes && Modernizr.inputtypes.time))    
    $('.timepicker_basic').datetimepicker({
       pickDate: false,
       language: $(".dropdown.languages > a > img").attr("data-locale") || 'en',
      })
    $('.timepicker_seconds').datetimepicker({
       pickDate: false,
       language: $(".dropdown.languages > a > img").attr("data-locale") || 'en',  
       useSeconds: true,
      }) 