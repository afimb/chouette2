jQuery ->
  if(!(Modernizr.inputtypes && Modernizr.inputtypes.time))    
    $('.timepicker_basic').timepicker(
      template: false,
      showInputs: false,
      minuteStep: 1,
      showMeridian: false,
      )
    $('.timepicker_seconds').timepicker(
      template: false,
      showInputs: false,
      minuteStep: 1,
      secondStep: 1,
      showMeridian: false,
      showSeconds: true
      ) 