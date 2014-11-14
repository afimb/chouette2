jQuery ->

  make_ajax_pagination = () ->
    $.get(this.href, null, null, 'script')
    false

  $(document).on("click", '.group_of_lines.show .lines_detail .pagination a', make_ajax_pagination)
