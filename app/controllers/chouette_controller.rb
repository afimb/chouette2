class ChouetteController < InheritedResources::Base
  
  before_filter :switch_referential

  def switch_referential
    Apartment::Database.switch(referential.slug)
  end 

  def referential
    @referential = Referential.find params[:referential_id]  
  end 

end