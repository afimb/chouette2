class SearchStopAreaInput < Formtastic::Inputs::SearchInput
  
  def search
    if options[:json]
      tokenLimit = options[:tokenLimit].present? ? options[:tokenLimit] : "null"
      template.content_tag( :script,
       ("$(document).ready(function() {

           var item_name = function( item){
              var result = item.short_name;
              if ( item.short_registration_number != '' ) {
                 result += ' <small>[' + item.short_registration_number + ']</small>';
              }
              return result;
           };

           var item_localization = function( item){
              var localization = item.zip_code + ' ' + item.short_city_name;
              return localization;         
           };

           var item_format = function( item ){                       
              var name = item_name( item );  
              var localization = item_localization( item );
              
              html_result = '<li>';
              html_result += '<span><image src=\"' + item.stop_area_path + '\" height=\"25px\" width=\"25px\"></span>'
              if(name != '')
              {
                html_result += '<span style=\"height:25px; line-height:25px; margin-left: 5px; \">' + name + '</span>' ;    
              }              
              if(localization != '')
              {
                html_result += '<small style=\"height:25px; line-height:25px; margin-left: 10px; color: #555; \">' + localization + '</small>';
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
                  'data-model-name' => object.class.model_name.human
                })
  end

end
