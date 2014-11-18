class StopAreaChildrenController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|
      format.json { render :json => children_maps }
    end
  end

  protected

  def children_maps
    children.map { |c| c.attributes}
  end

  def children
    referential.stop_areas.find(params[:stop_area_id]).possible_children.select{ |p| p.name =~ /#{params[:q]}/i  }
  end

end
