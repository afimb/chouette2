jQuery ->
    <% Export.references_types.each do |type| %>
    $("#<%= export_references_type(type).input_id %>" ).tokenInput('<%= references_referential_exports_path(@referential, :type => export_references_type(type).relation_name, :format => :json) %>', { prePopulate: $('#').data('pre'), minChars: 3 });
    <% end %>
