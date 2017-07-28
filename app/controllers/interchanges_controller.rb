class InterchangesController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::Interchange
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

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

  protected

  def collection
    @q = referential.interchanges.search(params[:q])
    @interchanges ||= @q.result(:distinct => true).order(:name).page(params[:page])
  end

  def resource_url(interchange = nil)
    referential_interchange_path(referential, interchange || resource)
  end

  def collection_url
    referential_interchanges_path(referential)
  end

  def interchange_params
    params.require(:interchange).permit(:objectid, :object_version, :creation_time, :creator_id, :version_date, :name, :priority, :planned, :guaranteed, :advertised, :stay_seated, :from_point, :from_visit_number, :to_point, :to_visit_number, :from_vehicle_journey, :to_vehicle_journey  )
  end

end
