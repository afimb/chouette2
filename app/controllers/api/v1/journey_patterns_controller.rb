class Api::V1::JourneyPatternsController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::JourneyPattern, :finder => :find_by_objectid!

  belongs_to :line, :parent_class => Chouette::Line, :optional => true, :finder => :find_by_objectid!, :param => :line_id do
    belongs_to :route, :parent_class => Chouette::Route, :optional => true, :finder => :find_by_objectid!, :param => :route_id
  end
  
protected

  def collection
    @journey_patterns ||= parent.journey_patterns
  end 

end

