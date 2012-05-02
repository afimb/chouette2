class ConnectionLinkAreasController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|  
      format.json { render :json => areas_maps }  
    end  
  end

  def areas_maps
    areas.collect do |area|
      { :id => area.id.to_s, :name => "#{area.name} #{area.country_code}" }
    end
  end

  def areas 
    referential.connection_links.find(params[:connection_link_id]).possible_areas.select{ |p| p.name =~ /#{params[:q]}/i  }       
  end

end
