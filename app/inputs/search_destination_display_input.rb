class SearchDestinationDisplayInput < Formtastic::Inputs::SearchInput

  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {

           var item_name = function( item ){
              var name = item.name;
              var front_text = item.front_text == '' ? '' : ' (' + item.front_text + ')';

              return item.name + front_text;
           };

          var item_format = function(item){
              var name = item_name( item );

              html_result = '<li>';
              if(name != '')
              {
                html_result += name;
              }
              html_result += '</li>';
              return html_result;
          };
           $('##{dom_id}').tokenInput('#{options[:json]}', {
             zindex: 1061,
             disabled: #{options[:disabled] || false},
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             preventDuplicates: true,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',
             resultsFormatter: item_format,
             tokenFormatter: item_format,
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
    css_class =  super[:class]
    super.merge({
                  :required          => nil,
                  :autofocus         => nil,
                  :class             => "#{css_class} token-input",
                  'data-model-name' => (object.nil? || object.class.nil?) ? 'Chouette::DestinationDisplay' : object.class.model_name.human
                })
  end

end
