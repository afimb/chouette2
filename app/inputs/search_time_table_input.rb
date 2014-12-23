class SearchTimeTableInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {
          var time_table_formatter = function(item){
            var day_types = '';
            if ( item.day_types.length >0 ){
              day_types = '<span class=\"day_types\">' +  item.day_types + '</span>' ;
            }
            var tags = '';
            if ( item.tags.length >0 ){
              tags = '<div class=\"info\">' +  item.tags + '</div>' ;
            }
            return '<li><div class=\"comment\">' + item.comment +
                    '</div><div class=\"info\">' + item.time_table_bounding + '  ' + day_types + '</div>' +
                    tags + '</li>';
          };
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             zindex: 1061,
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             propertyToSearch: 'comment',
             preventDuplicates: true,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: time_table_formatter,
             tokenFormatter: time_table_formatter,
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
                  'data-model-name' => object.class.model_name.human
                })
  end

end
