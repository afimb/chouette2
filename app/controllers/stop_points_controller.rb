class StopPointsController < ChouetteController
  defaults :resource_class => Chouette::StopPoint

  respond_to :html

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  def index     
    index!
  end

  def create
    create! do |success, failure|
      success.html { redirect_to referential_line_route_path(@referential,@line,@route) }
    end
  end


  def sort
    parent.reorder!( params[:stop_point])
    render :nothing => true
  end

end

