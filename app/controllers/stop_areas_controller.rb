class StopAreasController < ChouetteController
  defaults :resource_class => Chouette::StopArea

#  belongs_to :network, :parent_class => Potimart::Network do
  belongs_to :line, :parent_class => Chouette::Line, :optional => true
#  end

  respond_to :html, :kml

  # def complete
  #   @stop_areas = line.stop_areas
  #   render :layout => false
  # end

  # def show
  #   @map = StopAreaMap.new stop_area
  #   show! do |format|
  #     unless stop_area.position or params[:default]
  #       format.kml { render :nothing => true, :status => :not_found }
  #     end
  #   end
  # end
  
  # def edit
  #   stop_area.position ||= stop_area.default_position

  #   @map = StopAreaMap.new stop_area
  #   @map.editable = true
  #   edit!
  # end

  protected

  alias_method :stop_area, :resource

  # def network
  #   @network ||= Potimart::Network.find(params[:network_id])     
  # end

  def line
    @line ||= Chouette::Line.find(params[:line_id]) if params[:line_id]      
  end

  def collection
    @q = line ? line.stop_areas.search(params[:q]) : referential.stop_areas.search(params[:q])
    @stop_areas ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page], :per_page => 10)
  end

end
