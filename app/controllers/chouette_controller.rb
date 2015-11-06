class ChouetteController < BreadcrumbController

  include ApplicationHelper
  include BreadcrumbHelper
  
  before_action :switch_referential
  
  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end 

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]  
  end 
  
end
