(($) ->
  $ ->
    $('.ce-hide').removeClass 'ce-hide'
    $('[data-ce-action]').click ->
      action = $(this).data('ce-action')
      id = $(this).data('ce-id')
      $map = $('#'+id)
      height = $(window).height()
      if (action == 'map-fullscreen')
        if parseInt($map.css('height')) == height
          $map.css('width', '')
          $map.css('height', '')
        else
          $map.css('height', height).css('width', '100%')
        $map.find('i').toggleClass('fa-expand fa-compress')
        map.updateSize()
    return
  return
) jQuery
