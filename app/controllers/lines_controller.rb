class LinesController < ChouetteController
  defaults :resource_class => Chouette::Line
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  def show
    @map = LineMap.new referential, resource
    @routes = @line.routes.paginate(:page => params[:page], :per_page => 10)
    show!
  end

  protected

  def collection
    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page], :per_page => 10).includes([:network, :company])
  end

end
