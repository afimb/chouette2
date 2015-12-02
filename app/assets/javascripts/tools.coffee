(($) ->
  $ ->
    $('.ce-hide').removeClass 'ce-hide'
    sidebar = $('#sidebar').text().trim().length > 0
    if (sidebar)
      $('#map').before('<button id="ce-SidebarNavBlock" class="hide"><i class="fa fa-bars"></i></button>')
    $('[data-ce-action]').click (e) ->
      e.preventDefault()
      action = $(this).data('ce-action')
      id = $(this).data('ce-id')
      $map = $('#'+id)
      if (action == 'map-fullscreen')
        if $map.hasClass('ce-MapBlock-fullWidth')
          $map.removeClass('ce-MapBlock-fullWidth')
          $map.css('height', '')
        else
          offset_top = $map.offset().top + 2
          height = $(window).height() - offset_top
          $map.addClass('ce-MapBlock-fullWidth')
          $map.css('height', height)
        if sidebar
          $('#sidebar').toggleClass('hide')
          $('#sidebar').toggleClass('ce-SidebarFloatBlock')
          $('#ce-SidebarNavBlock').toggleClass('hide')
          $map.closest('.col-md-9, .col-md-12').toggleClass('col-md-9 col-md-12')
        $map.find('i').toggleClass('fa-expand fa-compress')
        map.updateSize()
      if sidebar
        $('#ce-SidebarNavBlock').click (e) ->
          e.preventDefault()
          $('.ce-SidebarFloatBlock').toggleClass('hide')
) jQuery
