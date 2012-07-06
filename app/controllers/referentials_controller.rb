class ReferentialsController < InheritedResources::Base
  respond_to :html

  def show 
     resource.switch
     show!
  end
  
  
end
