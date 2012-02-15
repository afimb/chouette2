class NetworksController < ChouetteController
  defaults :resource_class => Chouette::Network
  respond_to :html
  respond_to :xml
  respond_to :json

end
