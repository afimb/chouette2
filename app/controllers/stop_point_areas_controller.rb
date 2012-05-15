class StopPointAreasController < ChouetteController

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
    Chouette::StopPoint.area_candidates.select{ |p| p.name =~ /#{params[:q]}/i  }       
  end

end

