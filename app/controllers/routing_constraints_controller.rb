class RoutingConstraintsController < ChouetteController
  defaults :resource_class => Chouette::RoutingConstraint
  before_action :map, only: :show

  respond_to :html

  belongs_to :referential
  
  private

  def map
    @map = RoutingConstraintMap.new(resource.stop_areas).with_helpers(self)
  end

  def routing_constraint_params
    params.require(:routing_constraint).permit( :name, :comment, :line_ids, :stop_area_ids )
  end
end
