class RoutesController < ChouetteController
  defaults :resource_class => Chouette::Route

  respond_to :html, :xml, :json

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
  end

  def index     
    @per_page = 10
    index!
  end

  protected

  alias_method :route, :resource

  def collection
    @q = parent.routes.search(params[:q])
    @routes ||= 
      begin
        routes = @q.result(:distinct => true).order(:name)
        routes = routes.paginate(:page => params[:page], :per_page => @per_page) if @per_page.present?
        routes
      end
  end

end

