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
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
        build_breadcrumb :index
      }
    end
  end

  def show
    @map = ConnectionLinkMap.new(resource).with_helpers(self)
    show! do
        build_breadcrumb :show
    end
  end

  def select_areas
    @connection_link = connection_link
    @departure = connection_link.departure
    @arrival = connection_link.arrival
    build_breadcrumb :show
  end

  protected

  alias_method :connection_link, :resource

  def collection
    @q = referential.connection_links.search(params[:q])
    @connection_links ||= @q.result(:distinct => true).order(:name).page(params[:page])
  end

  def resource_url(connection_link = nil)
    referential_connection_link_path(referential, connection_link || resource)
  end

  def collection_url
    referential_connection_links_path(referential)
  end

  private

  def connection_link_params
    params.require(:connection_link).permit( :connection_link_type,:departure_id, :arrival_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :link_distance, :link_type, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration, :mobility_restricted_traveller_duration, :mobility_restricted_suitability, :stairs_availability, :lift_availability, :int_user_needs )
  end

end
