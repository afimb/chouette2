class StopAreasController < ChouetteController
  defaults :resource_class => Chouette::StopArea

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line, :optional => true, :polymorphic => true
    belongs_to :network, :parent_class => Chouette::Network, :optional => true, :polymorphic => true
    belongs_to :connection_link, :parent_class => Chouette::Network, :optional => true, :polymorphic => true
  end

  respond_to :html, :kml, :xml, :json

  # def complete
  #   @stop_areas = line.stop_areas
  #   render :layout => false
  # end

  def select_parent
    @stop_area = stop_area
    @parent = stop_area.parent
  end

  def add_children
    @stop_area = stop_area
    @children = stop_area.children
  end

  def add_routing_lines
    @stop_area = stop_area
    @lines = stop_area.routing_lines
  end

  def add_routing_stops
    @stop_area = stop_area
    @stops = stop_area.routing_stops
  end

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12
    index!
  end

  def show
    map.editable = false
    show! do |format|
      unless stop_area.position or params[:default]
        format.kml {
          render :nothing => true, :status => :not_found 
        }
        
      end
    end
  end
  
  def edit
    stop_area.position ||= stop_area.default_position

    map.editable = true
    edit!
  end

  def default_geometry
    count = referential.stop_areas.without_geometry.default_geometry!
    flash[:notice] = I18n.translate("stop_areas.default_geometry_success", :count => count)
    redirect_to referential_stop_areas_path(@referential)
  end

  protected
  
  alias_method :stop_area, :resource

  def map
    @map = StopAreaMap.new(stop_area).with_helpers(self)
  end

  def collection
    @q = parent.present? ? parent.stop_areas.search(params[:q]) : referential.stop_areas.search(params[:q])
    @stop_areas ||= 
      begin
        stop_areas = @q.result(:distinct => true).order(:name)
        stop_areas = stop_areas.paginate(:page => params[:page], :per_page => @per_page) if @per_page.present?
        stop_areas
      end
  end

end
