class SearchDestinationDisplayInput < Formtastic::Inputs::SearchInput

  #$('.stop-point-#{domId} ##{dom_id}').tokenInput('#{options[:json]}', {
  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      domId = options[:domId].present? ? options[:domId] : ""
      template.content_tag( :script,
       ("$(document).ready(function() {
          var item_format = function(item){
            return '<li>' + item.name + '</li>';
          };
           $('##{dom_id}-#{domId}').tokenInput('#{options[:json]}', {
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
                  'data-model-name' => 'Chouette::DestinationDisplay' #object.class.model_name.human #TODO
                })
  end

end
