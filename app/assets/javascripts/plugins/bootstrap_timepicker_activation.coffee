jQuery ->
  if(!(Modernizr.inputtypes && Modernizr.inputtypes.time))    
    $('input[type="time"]').timepicker(
      template: false,
      showInputs: false,
      minuteStep: 1,
      showMeridian: false,
      )