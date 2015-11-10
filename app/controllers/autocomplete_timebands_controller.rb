class AutocompleteTimebandsController < InheritedResources::Base
  respond_to :json, :only => [:index]

  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_timebands
    if params[:route_id]
      referential.timebands.joins( vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
    else
      referential.timebands
    end
  end

  def referential_timebands
    @referential_timebands ||= select_timebands
  end

  def collection
    @timebands = referential_timebands.select{ |p| p.fullname =~ /#{params[:q]}/i  }
  end
end
