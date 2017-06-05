class Api::V1::CodespaceController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::Codespace, :finder => :find_by_objectid!

protected

  def collection
    @codespaces ||=  ( @referential ? @referential.codespaces.search(params[:q]).result(:distinct => true) : [])

  end 

end

