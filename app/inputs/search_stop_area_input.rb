class SearchStopAreaInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
    template.content_tag( :script,
       ("$(document).ready(function() {
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             crossDomain: false,
             tokenLimit: 1,
             minChars: 3,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: function(item){ return '<li><div class=\"name\">' + item.name + '</div><div class=\"info\">' +  item.zip_code + ' ' + item.city_name + '</div></li>' },
             tokenFormatter: function(item) { return '<li><p>' + item.name + '</p></li>' }
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
