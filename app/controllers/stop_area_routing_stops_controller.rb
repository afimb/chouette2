class StopAreaRoutingStopsController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|  
      format.json { render :json => routing_stops_maps }  
    end  
  end

  def routing_stops_maps
    routing_stops.collect do |stop|
      { :id => stop.id.to_s, :name => "#{stop.name} #{stop.country_code}" }
    end
  end

  def routing_stops 
    referential.stop_areas.find(params[:stop_area_id]).possible_children.select{ |p| p.name =~ /#{params[:q]}/i  }       
  end

end
