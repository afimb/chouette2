class StopAreaParentsController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|
      format.json { render :json => parents_maps }
    end
  end

  def parents_maps
    parents.map {|area| area.attributes.merge( :area_type => t("area_types.label.#{area.area_type.underscore}"))}
  end

  def parents
    referential.stop_areas.find(params[:stop_area_id]).possible_parents.select{ |p| p.name =~ /#{params[:q]}/i  }
  end

end
