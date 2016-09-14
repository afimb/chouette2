class RouteSectionsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::RouteSection

  respond_to :html
  respond_to :kml, :only => :show

  belongs_to :referential

  before_action :save_return_to_path, only: [:edit, :create_to_edit]
  before_action ->(controller) { build_breadcrumb controller.action_name }

  helper_method :search

  def index
    index!
  end

  def new
    @stop_areas = referential.stop_areas.with_geometry.order :name
    new!
  end

  def show
    @map = RouteSectionMap.new(resource).with_helpers(self)
    show!
  end

  def edit
    @map = RouteSectionMap.new(resource, true).with_helpers(self)
    edit!
  end

  def update
    update! { session.delete(:return_to) }
  end

  def create
    create! { session.delete(:return_to) }
  end

  def create_to_edit
    route_section = Chouette::RouteSection.create(route_section_params)
    if route_section.id
      redirect_to edit_referential_route_section_path(referential, route_section)
    else
      flash[:alert] = I18n.t('route_sections.unable_to_contact_server')
      redirect_to :back
    end
  end

  protected

  def save_return_to_path
    session[:return_to] = params[:return_to] if params[:return_to]
  end

  def collection
    # if q = params[:q]
    #   @route_sections ||= Chouette::RouteSection.joins(:departure, :arrival).where(departure: {name: "#{q}"}).or.where(arrival: {name: "#{q}"})
    # end
    @route_sections ||= search.collection.includes(:departure, :arrival).page(params[:page])
  end

  def search
    @search ||= RouteSectionSearch.new(params[:route_section_search])
  end

  private

  def route_section_params
    params.require(:route_section).permit(:departure_id, :arrival_id, :editable_geometry, :no_processing)
  end

end
