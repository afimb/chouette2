class DestinationDisplaysController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::DestinationDisplay
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :js, :only => :index

  belongs_to :referential, :parent_class => Referential

  def index

    index! do |format|
      format.html {
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
      }
      build_breadcrumb :index
    end
  end

  def update
    Chouette::DestinationDisplayVia.delete_all(:destination_display_id => params[:id])
    update!
  end

  protected
  def collection
    @q = referential.destination_displays.search(params[:q])
    @destination_displays ||= @q.result(:distinct => true).order(:name).page(params[:page])
  end


  def resource_url(destination_display = nil)
    referential_destination_display_path(referential, destination_display || resource)
  end

  def collection_url
    referential_destination_display_path(referential)
  end

  def destination_display_params
    params.require(:destination_display).permit( :name, :front_text, :side_text, :vias_attributes => [:name, :side_text, :front_text], :destination_display_vias_attributes => [:destination_display_id, :via_id, :_destroy, :position] )
  end
end
