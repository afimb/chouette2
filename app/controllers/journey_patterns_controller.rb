class JourneyPatternsController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :collection]

  defaults :resource_class => Chouette::JourneyPattern

  respond_to :html
  respond_to :json, :only => :index
  respond_to :js, :only => [:new_vehicle_journey, :show]
  respond_to :kml, :only => :show

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  alias_method :route, :parent
  alias_method :journey_pattern, :resource

  def index
    index! do |format|
      format.html { redirect_to referential_line_route_path(@referential,@line,@route) }
    end
  end

  def create_resource(object)
    object.special_update
  end

  def show
    @map = JourneyPatternMap.new(journey_pattern).with_helpers(self)
    @stop_points = journey_pattern.stop_points.page(params[:page])
    show! do
      build_breadcrumb :show
    end
  end

  def new_vehicle_journey
    @vehicle_journey = Chouette::VehicleJourney.new(:route_id => route.id)
    @vehicle_journey.update_journey_pattern(resource)
    vehicle_journey_category = params[:journey_category] ? "vehicle_journey_#{params[:journey_category]}" : 'vehicle_journey'
    render "#{vehicle_journey_category.pluralize}/select_journey_pattern"
  end

  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  def collection
    @q = route.journey_patterns.search( params[:q])
    @journey_patterns ||= @q.result(:distinct => true).order(:name)
  end


  private

  def journey_pattern_params
    params.require(:journey_pattern).permit(:route_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :registration_number, :published_name, :departure_stop_point_id, :arrival_stop_point_id, {:stop_point_ids => [], :destination_display_ids => []})
  end

end
