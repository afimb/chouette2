class ReferentialsController < InheritedResources::Base

  before_filter :switch_referential

  def switch_referential
    Apartment::Database.switch(referential.slug)
  end 

end
