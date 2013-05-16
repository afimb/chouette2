class Api::V1::RoutesController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::Route, :finder => :find_by_objectid!

  belongs_to :line, :parent_class => Chouette::Line, :optional => true, :finder => :find_by_objectid!, :param => :line_id
  
protected

  def collection
    @routes ||= parent.routes
  end 
end

