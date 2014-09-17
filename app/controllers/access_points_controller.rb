class AccessPointsController < ChouetteController
  defaults :resource_class => Chouette::AccessPoint

  belongs_to :referential do
    belongs_to :stop_area, :parent_class => Chouette::StopArea, :optional => true, :polymorphic => true
  end

  respond_to :html, :kml, :xml, :json

  def index    
    request.format.kml? ? @per_page = nil : @per_page = 12

    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      }
    end       
  end

  def show
    map.editable = false
    @generic_access_links = @access_point.generic_access_link_matrix
    @detail_access_links = @access_point.detail_access_link_matrix
    show! do |format|
      unless access_point.position or params[:default]
        format.kml {
          render :nothing => true, :status => :not_found 
        }
        
      end
      add_breadcrumb Referential.human_attribute_name("stop_areas"), referential_stop_areas_path(@referential)
      add_breadcrumb @stop_area.name, referential_stop_area_path(@referential, @stop_area)
    end
  end
  
  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("stop_areas"), referential_stop_areas_path(@referential)
      add_breadcrumb @stop_area.name, referential_stop_area_path(@referential, @stop_area)
    end
  end

  def edit
    access_point.position ||= access_point.default_position
    map.editable = true
    edit! do
      add_breadcrumb Referential.human_attribute_name("stop_areas"), referential_stop_areas_path(@referential)
      add_breadcrumb @stop_area.name, referential_stop_area_path(@referential, @stop_area)
      add_breadcrumb @access_point.name, referential_stop_area_access_point_path(@referential, @stop_area,@access_point)
    end
  end


  protected
  
  alias_method :access_point, :resource

  def map
    @map = AccessPointMap.new(access_point).with_helpers(self)
  end

  def collection
    @q = parent.access_points.search(params[:q])
    @access_points ||= 
      begin
        access_points = @q.result(:distinct => true).order(:name)
        access_points = access_points.paginate(:page => params[:page]) if @per_page.present?
        access_points
      end
  end

end
