class ReferentialsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]
  skip_before_action :switch_referential
  defaults :resource_class => Referential

  respond_to :html
  respond_to :json, :only => :show
  respond_to :js, :only => :show

  def new
    new! do
      @referential.data_format = current_organisation.data_format
    end
  end

  def show
     resource.switch
     show! do |format|
       format.json {
         render :json => { :lines_count => resource.lines.count,
                :networks_count => resource.networks.count,
                :vehicle_journeys_count => resource.vehicle_journeys.count + resource.vehicle_journey_frequencies.count,
                :time_tables_count => resource.time_tables.count,
                :referential_id => resource.id}
       }
       format.html { build_breadcrumb :show}

     end
  end

  protected

  alias_method :referential, :resource

  def resource
    @referential ||= current_organisation.referentials.find_by_id(params[:id])
  end

  def collection
    @referentials ||= current_organisation.referentials.order(:name)
  end

  def build_resource
    super.tap do |referential|
      referential.user_id = current_user.id
      referential.user_name = current_user.name
    end
  end

  def create_resource(referential)
    referential.organisation = current_organisation
    super
  end

  private
  def referential_params
    params.require(:referential).permit( :id, :name, :prefix, :time_zone, :upper_corner, :lower_corner, :organisation_id, :projection_type, :data_format )
  end

end
