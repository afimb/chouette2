class AccessLinksController < ChouetteController
  defaults :resource_class => Chouette::AccessLink

  belongs_to :referential do
    belongs_to :access_point, :parent_class => Chouette::AccessPoint, :optional => true, :polymorphic => true
    belongs_to :stop_area, :parent_class => Chouette::StopArea, :optional => true, :polymorphic => true
  end

  respond_to :html, :kml, :xml, :json


  def index
    request.format.kml? ? @per_page = nil : @per_page = 12
    index!
  end

  def show
    #@map = AccessLinkMap.new(resource).with_helpers(self)
    show!
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
    @access_link = Chouette::AccessLink.new(data)
    new!
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
    edit!
  end
  protected
  
  alias_method :access_link, :resource

#  def map
#    @map = AccessLinkMap.new(access_link).with_helpers(self)
#  end

  def collection
    @q = parent.access_links.search(params[:q])
    @access_links ||= 
      begin
        access_links = @q.result(:distinct => true).order(:name)
        access_links = access_links.paginate(:page => params[:page]) if @per_page.present?
        access_links
      end
  end

end
