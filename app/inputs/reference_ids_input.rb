class ReferenceIdsInput < Formtastic::Inputs::SearchInput
  
  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {           

           $('##{options[:id]}').tokenInput('#{options[:json]}', {
             zindex: 1061,
             disabled: #{options[:disabled] || false},
             crossDomain: false,
             tokenLimit: #{tokenLimit},
             minChars: 2,
             preventDuplicates: true,
             hintText: '#{options[:hint_text]}',
             noResultsText: '#{options[:no_result_text]}',
             searchingText: '#{options[:searching_text]}',        
           });
        });").html_safe)
    end
  end

  def to_html
    input_wrapping do
      label_html <<
        builder.text_field(method, input_html_options) <<
          search
    end
  end

  def input_html_options    
    css_class =  super[:class]
    super.merge({
                  :required          => nil,
                  :autofocus         => nil,
                  :class             => "#{css_class} token-input",
                  'data-model-name' => object.class.model_name.human
                })
  end

end
