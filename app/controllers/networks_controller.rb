class NetworksController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::Network
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

  def show
    @map = NetworkMap.new(resource).with_helpers(self)
    show! do
      build_breadcrumb :show
    end
  end

  def index
    index! do |format|
      format.html {
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
      }
      build_breadcrumb :index
    end
  end

  protected

  def collection
    @q = referential.networks.search(params[:q])
    @networks ||= @q.result(:distinct => true).order(:name).page(params[:page])
  end

  def resource_url(network = nil)
    referential_network_path(referential, network || resource)
  end

  def collection_url
    referential_networks_path(referential)
  end

  def network_params
    params.require(:network).permit(:objectid, :object_version, :creation_time, :creator_id, :version_date, :description, :name, :registration_number, :source_name, :source_type_name, :source_identifier, :comment )
  end

end
