class Api::V1::StopAreasController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::StopArea, :finder => :find_by_objectid!

  belongs_to :line, :parent_class => Chouette::Line, :optional => true, :finder => :find_by_objectid!, :param => :line_id do
    belongs_to :route, :parent_class => Chouette::Route, :optional => true, :finder => :find_by_objectid!, :param => :route_id
  end
  
protected

  def collection
    if parent
      @stop_areas ||= parent.stop_areas.search(params[:q]).result
    else
      @stop_areas ||= @referential.stop_areas.search(params[:q]).result(:distinct => true)
    end
  end 

end

