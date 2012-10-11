jQuery ->

  switch_lines = (event) -> 
    event.preventDefault()
    $('.group_of_lines.show .lines_detail').toggle('slow')
    $('a.lines .switcher').toggle()

  $('.group_of_lines.show a.lines').click(switch_lines)


  make_ajax_pagination = () ->
    $.get(this.href, null, null, 'script')
    false

  $('.group_of_lines.show .lines_detail .pagination a').live("click", make_ajax_pagination)
