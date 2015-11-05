(($) ->
  $ ->
    $('.ce-hide').removeClass 'ce-hide'
    $('#map').before('<button id="ce-SidebarNavBlock" class="hide"><i class="fa fa-bars"></i></button>')
    $('[data-ce-action]').click ->
      action = $(this).data('ce-action')
      id = $(this).data('ce-id')
      $map = $('#'+id)
      if (action == 'map-fullscreen')
        if $map.hasClass('ce-isExpanded')
          $map.removeClass('ce-isExpanded')
          $map.css('width', '')
          $map.css('height', '')
        else
          offset_top = $map.offset().top + 2
          height = $(window).height() - offset_top
          $map.addClass('ce-isExpanded')
          $map.css('height', height).css('width', '100%')
        $('#sidebar').toggleClass('hide')
        $('#sidebar').toggleClass('ce-SidebarFloatBlock')
        $('#ce-SidebarNavBlock').toggleClass('hide')
        $map.closest('.col-md-9, .col-md-12').toggleClass('col-md-9 col-md-12')
        $map.find('i').toggleClass('fa-expand fa-compress')
        map.updateSize()
      $('#ce-SidebarNavBlock').click ->
        $('.ce-SidebarFloatBlock').toggleClass('hide')
    return
  return
) jQuery
