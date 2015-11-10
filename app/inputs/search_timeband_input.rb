class SearchTimebandInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      template.content_tag( :script,
                            ("$(document).ready(function() {
          var timeband_formatter = function(item){
            return '<li>' + item.name + '</li>';
          };
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             zindex: 1061,
             crossDomain: false,
             tokenLimit: 1,
             minChars: 2,
             propertyToSearch: 'name',
             preventDuplicates: true,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: timeband_formatter,
             tokenFormatter: timeband_formatter,
           });
        });").html_safe)
    end
  end

  def to_html
    input_wrapping do
      label_html <<
          builder.search_field(method, input_html_options) <<
          search
    end
  end

  def input_html_options
    super.merge({
                    required:             nil,
                    autofocus:            nil,
                    class:                'token-input',
                    :'data-model-name' => object.class.model_name.human
                })
  end

end
