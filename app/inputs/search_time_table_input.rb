class SearchTimeTableInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             preventDuplicates: true,
             queryParam: 'q[comment_cont]',
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: function(item){ return '<li><div class=\"comment\">' + item.comment + '</div><div class=\"info\">' + item.time_table_bounding + '</div><div class=\"info\">' +  item.composition_info + '</div></li>' },
             tokenFormatter: function(item){ return '<li><div class=\"comment\">' + item.comment + '</div><div class=\"info\">' + item.time_table_bounding + '</div><div class=\"info\">' +  item.composition_info + '</div></li>' },
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
