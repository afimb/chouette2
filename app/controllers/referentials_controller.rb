class ReferentialsController < BreadcrumbController

  defaults :resource_class => Referential
  
  respond_to :html
  respond_to :json, :only => :show
  respond_to :js, :only => :show

  def show
     resource.switch
     show! do |format|
       format.json {
         render :json => { :lines_count => resource.lines.count,
                :networks_count => resource.networks.count,
                :vehicle_journeys_count => resource.vehicle_journeys.count,
                :time_tables_count => resource.time_tables.count,
                :referential_id => resource.id}
       }
       format.html { build_breadcrumb :show}
       
     end
  end

  protected
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

  def permitted_params
    params.permit(referential: [ :name, :slug, :prefix, :time_zone, :upper_corner, :lower_corner, :organisation_id  ])
  end  

end
