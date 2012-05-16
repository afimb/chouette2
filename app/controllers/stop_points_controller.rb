class StopPointsController < ChouetteController
  defaults :resource_class => Chouette::StopPoint

  respond_to :html

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  alias_method :route, :parent

  def sort
    begin
      route.reorder!( params[:stop_point])
      flash[:notice] = t("stop_points.reorder_success")
    rescue => e
      flash[:alert] = t("stop_points.reorder_failure")
    end
    respond_to do |format|
      format.html { redirect_to referential_line_route_stop_points_path(@referential,@line,@route) }
    end
  end

end

