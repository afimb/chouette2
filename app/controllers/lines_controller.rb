class LinesController < InheritedResources::Base
  defaults :resource_class => Chouette::Line
  helper_method :sort_column, :sort_direction
  respond_to :html
  respond_to :xml
  respond_to :json

  protected

  def collection
    @lines ||= Chouette::Line.all.order_by [[sort_column.to_sym, sort_direction.to_sym]]
  end

  private

  def sort_column  
    %w(name number).include?(params[:sort]) ? params[:sort] : "name"
  end  
    
  def sort_direction  
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end  

end
