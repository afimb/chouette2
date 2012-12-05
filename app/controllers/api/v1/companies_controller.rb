class Api::V1::CompaniesController < Api::V1::ChouetteController
  inherit_resources

  defaults :resource_class => Chouette::Company, :finder => :find_by_objectid!

protected

  def collection
    @companies ||= referential.companies
  end 

end

