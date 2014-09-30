module PaginationHelper
  def paginated_content(models, default_partial_name = nil, options = {})
    default_options = {:delete => true, :edit => true}
    options = default_options.merge(options)
    
    return "" if models.blank?
    
    html = ""
    models.each_slice(3) do |row_models|
      html += '<div class="row">'
      row_models.each do |model|
        partial_name = default_partial_name || model.class.name.underscore.gsub("chouette/", "")
        html += '<div  class="col-md-4">' + (render :partial => partial_name, :object => model, :locals => options).to_s + '</div>'
      end
      html += '</div>'
    end
    html.html_safe
  end
end
