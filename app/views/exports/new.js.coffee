jQuery ->
    <% Export.references_types.map { |type| type_ids_model_references_type( Export, type)}.each do |rt| %>
       $("textarea.<%= rt.input_class %>").tokenInput('<%= references_referential_compliance_check_tasks_path(@referential, :type => rt.relation_name, :format => :json) %>', { prePopulate: $('#').data('pre'), minChars: 1, hintText: '<%= t('search_hint') %>', noResultsText: '<%= t('no_result_text') %>', searchingText: '<%= t('searching_term') %>'});
    <% end %>
