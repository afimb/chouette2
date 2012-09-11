jQuery ->
  update_infos = (json) ->
    info = $('#referential_'+json.referential_id+' .info')
    update_info = (key, value) ->
      $(info.find('.'+key)[0]).text( value) if key.match(/_count$/)
    $.each( json, update_info)
    
  update_referential_details = (ref) -> 
    ref_id = $(ref).attr("id").match( /(\d+)$/)[0]
    $.getJSON( '/referentials/'+ref_id+'.json', update_infos)

  update_referential_details(ref) for ref in $('.referentials.index .referential')

