class StopPointAreasController < ChouetteController

  respond_to :json, :only => :index

  def index
    respond_to do |format|
      format.json { render :json => areas_maps }
    end
  end

  def areas_maps
    areas.map {|area| area.attributes.merge( :area_type => t("area_types.label.#{area.area_type.underscore}"))}
  end

  def areas
    Chouette::StopPoint.area_candidates.select{ |p| p.name =~ /#{params[:q]}/i  }
  end

end

