class RoutesController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::Route

  respond_to :html, :xml, :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :show

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
  end

  def index
    index! do |format|
      format.html {redirect_to referential_line_path(@referential, @line)}
    end
  end


  def edit_stop_points
    @route = route
    build_breadcrumb :edit
  end


  def edit_boarding_alighting
    @route = route
    build_breadcrumb :edit
  end

  def save_boarding_alighting
    @route = route
    if @route.update_attributes!(route_params)
      redirect_to referential_line_route_path(@referential, @line, @route)
    else
      render "edit_boarding_alighting"
    end
  end

  def save_stop_points
    @route = route
    puts route.stop_points.inspect
    if @route.update_attributes!(route_params)
      redirect_to referential_line_route_path(@referential, @line, @route)
    else
      render "edit_stop_points"
    end
  end

  def show
    @map = RouteMap.new(route).with_helpers(self)
    show! do
      build_breadcrumb :show
    end
  end

  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  def destroy
    destroy! do |success, failure|
      success.html {redirect_to referential_line_path(@referential, @line)}
    end
  end

  def create
    create! do |success, failure|
      success.html {redirect_to referential_line_path(@referential, @line)}
      failure.html {flash[:alert] = route.errors[:flash]; render :action => :new}
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
          routes = routes.page(params[:page]) if @per_page.present?
          routes
        end
  end

  private

  def route_params
    params.require(:route).permit(:direction_code, :wayback_code, :line_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :opposite_route_id, :published_name, :number, :direction, :wayback,
                                  {stop_points_attributes: [:id, :_destroy, :position, :for_boarding, :for_alighting, :scheduled_stop_point_id_or_stop_area_objectid_key, :scheduled_stop_point_name,
                                                            {booking_arrangement_attributes:
                                                                 [:id, :booking_note, :book_when, :booking_access, :minimum_booking_period, :latest_booking_time,
                                                                  {booking_contact_attributes: [:_destroy, :id, :phone, :url, :fax, :email, :contact_person, :further_details]}, :buy_when => [], :booking_methods => []]}
                                  ]},
                                  routes_route_points_attributes: [:id, :_destroy, :position, route_point_attributes: [:id, :scheduled_stop_point_id_or_stop_area_objectid_key, :scheduled_stop_point_name]])
  end

end

