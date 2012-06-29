class NetworksController < ChouetteController
  defaults :resource_class => Chouette::Network
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  def show
    @map = NetworkMap.new(resource).with_helpers(self)
    show!
  end

  protected

  def collection    
    @q = referential.networks.search(params[:q])
    @networks ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page], :per_page => 10)
  end

  def resource_url(network = nil)
    referential_network_path(referential, network || resource)
  end

  def collection_url
    referential_networks_path(referential)
  end
end
