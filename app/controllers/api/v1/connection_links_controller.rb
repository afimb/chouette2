class Api::V1::ConnectionLinksController < Api::V1::ChouetteController
  inherit_resources

  defaults :resource_class => Chouette::ConnectionLink, :finder => :find_by_objectid!

protected

  def collection
    @connection_links ||= referential.connection_links.search(params[:q]).result(:distinct => true)
  end 

end

