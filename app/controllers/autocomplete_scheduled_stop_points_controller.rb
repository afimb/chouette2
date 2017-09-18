class AutocompleteScheduledStopPointsController < InheritedResources::Base
  respond_to :json, :only => [:index]

  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def collection
    @scheduled_stop_points =  Chouette::ScheduledStopPoint.all.select{ |p| [p.name, p.objectid].grep(/#{params[:q]}/i).any?  }

    @stop_areas = referential.stop_areas.physical.select{ |p| [p.name, p.objectid].grep(/#{params[:q]}/i).any?  }

    @stop_areas.each do |stop_area|
      @scheduled_stop_points.push(  Chouette::ScheduledStopPoint.new( :stop_area => stop_area)
     )
    end

    @scheduled_stop_points
  end



end

