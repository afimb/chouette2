jQuery ->

  $('[data-toggle="popover"]').click ->
    $('[data-toggle="popover"]').not($(this)).popover('hide');

  $('body').click ->
    $('[data-toggle="popover"]').not($(this)).popover('hide');
