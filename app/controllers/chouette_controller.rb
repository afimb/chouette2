class ChouetteController < InheritedResources::Base

  include ApplicationHelper
  
  before_filter :switch_referential

  def switch_referential
    Apartment::Database.switch(referential.slug)
  end 

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]  
  end 

end
