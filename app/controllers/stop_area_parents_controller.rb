class StopAreaParentsController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|
      format.json { render :json => parents_maps }
    end
  end

  def parents_maps
    parents.map { |p| p.attributes}
  end

  def parents
    referential.stop_areas.find(params[:stop_area_id]).possible_parents.select{ |p| p.name =~ /#{params[:q]}/i  }
  end

end
