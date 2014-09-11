class ConnectionLinksController < ChouetteController
  defaults :resource_class => Chouette::ConnectionLink

  belongs_to :referential do
    belongs_to :departure, :parent_class => Chouette::StopArea, :optional => true
    belongs_to :arrival, :parent_class => Chouette::StopArea, :optional => true
  end

  respond_to :html, :xml, :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  def index    
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      }
    end       
  end

  def show
    @map = ConnectionLinkMap.new(resource).with_helpers(self)
    show! do
      add_breadcrumb Referential.human_attribute_name("connection_links"), referential_connection_links_path(@referential)
    end
  end

  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("connection_links"), referential_connection_links_path(@referential)
    end
  end
  
  def edit
    edit! do
      add_breadcrumb Referential.human_attribute_name("connection_links"), referential_connection_links_path(@referential)
      add_breadcrumb @connection_link.name, referential_connection_link_path(@referential, @connection_link)
    end
  end


  def select_areas
    @connection_link = connection_link
    @departure = connection_link.departure
    @arrival = connection_link.arrival
    add_breadcrumb Referential.human_attribute_name("connection_links"), referential_connection_links_path(@referential)
    add_breadcrumb @connection_link.name, referential_connection_link_path(@referential, @connection_link)
  end

  protected
  
  alias_method :connection_link, :resource

  def collection    
    @q = referential.connection_links.search(params[:q])
    @connection_links ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page])
  end

  def resource_url(connection_link = nil)
    referential_connection_link_path(referential, connection_link || resource)
  end

  def collection_url
    referential_connection_links_path(referential)
  end

end
