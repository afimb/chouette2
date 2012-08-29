class ReferentialsController < InheritedResources::Base
  respond_to :html

  def show 
     resource.switch
     show!
  end
  
  protected
  def resource
    @referential ||= current_organisation.referentials.find_by_id(params[:id])
  end
  def collection    
    @referentials ||= current_organisation.referentials
  end
  
end
