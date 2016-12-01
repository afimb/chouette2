class AccessLinksController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::AccessLink

  belongs_to :referential do
    belongs_to :access_point, :parent_class => Chouette::AccessPoint, :optional => true, :polymorphic => true
    belongs_to :stop_area, :parent_class => Chouette::StopArea, :optional => true, :polymorphic => true
  end

  respond_to :html, :xml, :json
  respond_to :kml, :only => :show

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12
    index!
  end

  def show
    @map = AccessLinkMap.new(resource).with_helpers(self)
    @access_point = Chouette::AccessPoint.find(params[:access_point_id])
    #@access_link = Chouette::AccessLink.find(params[:id])
    @stop_area = @access_link.stop_area
    show! do |format|
      format.html {build_breadcrumb :show}
    end
  end

  def new
    @access_point = Chouette::AccessPoint.find(params[:access_point_id])
    data=params[:access_link]
    @stop_area = Chouette::StopArea.find(data[:stop_area_id])
    @orientation = data[:link_orientation_type]
    name=data[:name]
    if name.nil? || name.empty?
      if @orientation == "access_point_to_stop_area"
        name = "#{@access_point.name} -> #{@stop_area.name}"
      else
        name = "#{@stop_area.name} -> #{@access_point.name}"
      end
      data[:name] = name
    end
    @access_link = Chouette::AccessLink.new(data.permit!)
    new! do
      build_breadcrumb :new
    end
  end

  def create
    @access_point = Chouette::AccessPoint.find(params[:access_point_id])
    data=params[:access_link]
    @stop_area = Chouette::StopArea.find(data[:stop_area_id])
    @orientation = data[:link_orientation_type]
    create!
  end

  def edit
    @access_point = Chouette::AccessPoint.find(params[:access_point_id])
    @access_link = Chouette::AccessLink.find(params[:id])
    @stop_area = @access_link.stop_area
    @orientation = @access_link.link_orientation_type
    edit! do
      build_breadcrumb :edit
    end
  end

  def update
    @access_point = Chouette::AccessPoint.find(params[:access_point_id])
    @access_link = Chouette::AccessLink.find(params[:id])
    @stop_area = @access_link.stop_area
    @orientation = @access_link.link_orientation_type
    update! do |success, failure|
      build_breadcrumb :edit
    end
  end

  protected

  alias_method :access_link, :resource

  def collection
    @q = parent.access_links.search(params[:q])
    @access_links ||=
      begin
        access_links = @q.result(:distinct => true).order(:name)
        access_links = access_links.page(params[:page]) if @per_page.present?
        access_links
      end
  end


  private

  def access_link_params
    params.require(:access_link).permit(:access_link_type,:access_point_id, :stop_area_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :link_distance, :link_type, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration, :mobility_restricted_traveller_duration, :mobility_restricted_suitability, :stairs_availability, :lift_availability, :int_user_needs, :link_orientation, :link_orientation_type, :stop_area )
  end

end
