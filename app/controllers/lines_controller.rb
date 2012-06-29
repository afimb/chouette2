class LinesController < ChouetteController
  defaults :resource_class => Chouette::Line
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  def show
    @map = LineMap.new(resource).with_helpers(self)
    @routes = @line.routes
    show!
  end

  def destroy_all
    objects =
      get_collection_ivar || set_collection_ivar(end_of_association_chain.where(:id => params[:ids]))
    objects.destroy_all
    respond_with(objects, :location => smart_collection_url)
  end

  protected

  def collection
    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page], :per_page => 10).includes([:network, :company])
  end

end
