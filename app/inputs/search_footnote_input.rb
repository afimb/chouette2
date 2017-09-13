class SearchFootnoteInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {
            var footnote_formatter = function(item){
                html_result = '<li>';
                html_result += '['+item.code+'] '+item.label;
                html_result += '</li>';
                return html_result;
            };
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             zindex: 1061,
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             preventDuplicates: true,
             propertyToSearch: 'label',
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: footnote_formatter,
             tokenFormatter: footnote_formatter,
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
                  :required          => nil,
                  :autofocus         => nil,
                  :class             => 'token-input',
                  'data-model-name' => (object.nil? || object.class.nil?) ? 'Chouette::Footnote' : object.class.model_name.human
                })
  end

end
