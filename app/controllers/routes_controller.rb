class RoutesController < ChouetteController
  defaults :resource_class => Chouette::Route

  respond_to :html, :xml, :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :show

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
  end

  def index     
    index! do |format|
      format.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

  def show
    @map = RouteMap.new(route).with_helpers(self)
    @stop_points = route.stop_points.paginate(:page => params[:page])
    show!
  end

  # overwrite inherited resources to use delete instead of destroy 
  # foreign keys will propagate deletion)
  def destroy_resource(object)
        object.delete
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to referential_line_path(@referential,@line) }
    end
  end

#  def update
#    update! do |success, failure|
#      success.html { redirect_to referential_line_path(@referential,@line) }
#    end
#  end
  protected

  alias_method :route, :resource

  def collection
    @q = parent.routes.search(params[:q])
    @routes ||= 
      begin
        routes = @q.result(:distinct => true).order(:name)
        routes = routes.paginate(:page => params[:page]) if @per_page.present?
        routes
      end
  end

end

