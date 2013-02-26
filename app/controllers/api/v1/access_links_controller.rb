class Api::V1::AccessLinksController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::AccessLink, :finder => :find_by_objectid!

protected

  def collection
    @access_links ||=  ( @referential ? @referential.access_links.search(params[:q]).result(:distinct => true) : [])

  end 

end


