class ReferentialsController < InheritedResources::Base
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
     end
  end
  
  protected
  def resource
    @referential ||= current_organisation.referentials.find_by_id(params[:id])
  end
  def collection    
    @referentials ||= current_organisation.referentials
  end
  def create_resource(referential)
    referential.organisation = current_organisation
    super
  end
    
end
