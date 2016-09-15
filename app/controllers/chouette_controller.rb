class ChouetteController < BreadcrumbController

  include ApplicationHelper
  include BreadcrumbHelper
  
  before_action :check_organisation
  before_action :switch_referential
  
  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end 

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]  
  end
  
  protected

  def check_organisation
    redirect_to new_organisation_path unless current_organisation.present?
  end
  
end
