class LinesController < ChouetteController
  defaults :resource_class => Chouette::Line
  helper_method :sort_column, :sort_direction
  respond_to :html
  respond_to :xml
  respond_to :json

  protected

  def collection    
    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page], :per_page => 10).includes([:network, :company])
  end

  def sort_column  
    %w(name number).include?(params[:sort]) ? params[:sort] : "name"
  end  
    
  def sort_direction  
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end  

  def resource_url(line = nil)
    referential_line_path(referential, line || resource)
  end

  def collection_url
    referential_lines_path(referential)
  end

end
