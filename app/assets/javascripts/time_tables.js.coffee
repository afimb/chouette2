jQuery ->
# add trigger to hide/show application dates and periods
  switch_calendars = (event) -> 
    event.preventDefault()
    $('.time_tables .calendars.content').toggle('slow')
    $('a.calendars .switcher').toggle()

  $('.time_tables a.calendars').click(switch_calendars)

  switch_dates = (event) -> 
    event.preventDefault()
    $('.time_tables .dates.content').toggle('slow')
    $('a.dates .switcher').toggle()

  $('.time_tables a.dates').click(switch_dates)

  switch_periods = (event) -> 
    event.preventDefault()
    $('.time_tables .periods.content').toggle('slow')
    $('a.periods .switcher').toggle()

  $('.time_tables a.periods').click(switch_periods)

# add trigger when creating new date or period entries to activate datepicker
  tt_datepickerI18n = (index, element) ->
    # do nothig if a datepicker is already attached
    return if ($(element).hasClass('hasDatepicker') )
    $(element).datepicker({ 
                              dateFormat: "dd/mm/y",
                              dayNamesShort: $.datepicker.regional[ $('html').attr('lang') ].dayNamesShort, 
                              dayNames: $.datepicker.regional[ $('html').attr('lang') ].dayNames, 
                              monthNamesShort: $.datepicker.regional[ $('html').attr('lang') ].monthNamesShort, 
                              monthNames: $.datepicker.regional[ $('html').attr('lang') ].monthNames
                          })
    $(element).datepicker("setDate", $.datepicker.parseDate('dd/mm/y', $(element).val() ) ) if ($(element).val().indexOf('/') >= 0) 
    $(element).datepicker("setDate", $.datepicker.parseDate('yy-mm-dd', $(element).val() ) ) if ($(element).val().indexOf('/') < 0) 

  after_inserts = ->
    $('input[type="date"]').each(tt_datepickerI18n)
    
  bind_after_inserts = ->
    $('#periods_content').bind('insertion-callback',after_inserts)
    $('#dates_content').bind('insertion-callback',after_inserts)
    #after_inserts()
  
  $(document).on('cocoon:after-insert',after_inserts)  
    
  $(document).ready(bind_after_inserts) if $('.time_tables').length > 0
