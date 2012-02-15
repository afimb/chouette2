class CompaniesController < ChouetteController
  defaults :resource_class => Chouette::Company
  respond_to :html
  respond_to :xml
  respond_to :json

end
