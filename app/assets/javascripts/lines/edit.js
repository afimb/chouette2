var find_transport_submode = function() {
  var referential_id = parseInt($('body').data('referential'));
  if (referential_id > 0) {
    $ltsn = $('#line_transport_submode_name_input');
    $ltsn.hide();
    $.get("/referentials/" + referential_id + "/transport_submodes/" + $('#line_transport_mode_name').val(), function( data ) {
      $('#line_transport_submode_name').html('');
      if(data.length > 0) {
        $('#line_transport_submode_name').append('<option></option>');
        $(data).each( function(i, el) {
          $('#line_transport_submode_name').append('<option value="' + el[1] + '">' + el[0] + '</option>');
        });
        $ltsn.show();
      }
    });
  }
}

$(".lines.edit").ready( function() {
  $('#line_transport_mode_name').change( function() {
    find_transport_submode();
  });
});
