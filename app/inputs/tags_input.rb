class TagsInput < Formtastic::Inputs::StringInput
  
  def to_html
    input_wrapping do      
      label_html <<
        '<span id="tagsContainer"></span>'.html_safe << 
          builder.text_field(method, input_html_options)
    end
  end
  
  def input_html_options
    super.merge({
                  :required          => nil,
                  :autofocus         => nil,
                  :class             => 'tm-input',
                })
  end
  
end
