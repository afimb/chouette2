class Api::V1::StopAreasController < Api::V1::ChouetteController
  inherit_resources

  defaults :resource_class => Chouette::StopArea, :finder => :find_by_objectid!

  belongs_to :line, :parent_class => Chouette::Line, :optional => true, :finder => :find_by_objectid!, :param => :line_id do
    belongs_to :route, :parent_class => Chouette::Route, :optional => true, :finder => :find_by_objectid!, :param => :route_id
  end
  
protected

  def collection
    @stop_areas ||= parent.stop_areas
  end 

end

