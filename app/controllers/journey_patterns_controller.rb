class JourneyPatternsController < ChouetteController
  defaults :resource_class => Chouette::JourneyPattern

  respond_to :html
  respond_to :js, :only => [:new_vehicle_journey]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  alias_method :route, :parent

  def index     
    index! do |format|
      format.html { redirect_to referential_line_route_path(@referential,@line,@route) }
    end
  end

  def create_resource(object)
    object.special_update
  end

  def show
    #@map = RouteMap.new referential, route
    @stop_points = resource.stop_points.paginate(:page => params[:page], :per_page => 10)
    show!
  end

  def new_vehicle_journey
    @vehicle_journey = Chouette::VehicleJourney.new(:route_id => route.id)
    @vehicle_journey.update_journey_pattern(resource)
    render "vehicle_journeys/select_journey_pattern"
  end
end
