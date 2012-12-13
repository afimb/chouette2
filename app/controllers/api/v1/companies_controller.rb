class Api::V1::CompaniesController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::Company, :finder => :find_by_objectid!

protected

  def collection
    @companies ||=  ( @referential ? @referential.companies.search(params[:q]).result(:distinct => true) : [])

  end 

end

