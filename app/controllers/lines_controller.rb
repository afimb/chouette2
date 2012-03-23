class LinesController < ChouetteController
  defaults :resource_class => Chouette::Line
  respond_to :html
  respond_to :xml
  respond_to :json

  def show
    @map = LineMap.new referential, resource
    show!
  end

  protected

  def collection    
    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page], :per_page => 10).includes([:network, :company])
  end

  def resource_url(line = nil)
    referential_line_path(referential, line || resource)
  end

  def collection_url
    referential_lines_path(referential)
  end

end
