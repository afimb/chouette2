class JourneyPatternsController < ChouetteController
  defaults :resource_class => Chouette::JourneyPattern

  respond_to :html

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  alias_method :route, :parent

  def show
    #@map = RouteMap.new referential, route
    @stop_points = resource.stop_points.paginate(:page => params[:page], :per_page => 10)
    show!
  end
end
