class AutocompleteTimeTablesController < InheritedResources::Base
  respond_to :json, :only => [:index]

  before_filter :switch_referential

  def switch_referential
    Apartment::Database.switch(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_time_tables
    if params[:route_id]
      referential.time_tables.joins( vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
   else
      referential.time_tables
   end
  end

  def referential_time_tables
    @referential_time_tables ||= select_time_tables
  end

  def collection
    comment_selection = referential_time_tables.select{ |p| p.comment =~ /#{params[:q]}/i  }
    tag_selection = referential_time_tables.tagged_with( params[:q], :wild => true)
    @time_tables = (comment_selection + tag_selection).uniq
  end
end
