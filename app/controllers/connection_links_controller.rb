class ConnectionLinksController < ChouetteController
  defaults :resource_class => Chouette::ConnectionLink

  belongs_to :referential do
    #belongs_to :departure, :parent_class => Chouette::StopArea, :optional => false
    #belongs_to :arrival, :parent_class => Chouette::StopArea, :optional => false
  end

  respond_to :html, :xml, :json


  protected

  def collection    
    @q = referential.connection_links.search(params[:q])
    @connection_links ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page], :per_page => 10)
  end

  def resource_url(connection_link = nil)
    referential_connection_link_path(referential, connection_link || resource)
  end

  def collection_url
    referential_connection_links_path(referential)
  end

end
