class VehicleJourneysController < ChouetteController
  defaults :resource_class => Chouette::VehicleJourney

  respond_to :js, :only => [:select_journey_pattern, :edit, :new, :index]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  def select_journey_pattern
    if params[:journey_pattern_id]
      selected_journey_pattern = Chouette::JourneyPattern.find( params[:journey_pattern_id])

      @vehicle_journey = vehicle_journey
      @vehicle_journey.update_journey_pattern(selected_journey_pattern)
    end
  end

  def create
    create!(:alert => t('activerecord.errors.models.vehicle_journey.invalid_times'))
  end

  def update    
    update!(:alert => t('activerecord.errors.models.vehicle_journey.invalid_times'))
  end
  
  def index
    index! do
      @matrix ||= matrix
      if collection.out_of_bounds?
        redirect_to params.merge(:page => 1)
      end
      build_breadcrumb :index
    end
  end


  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  protected

  alias_method :vehicle_journey, :resource

  def collection
    @vehicle_filter = VehicleFilter.new( adapted_params)
    @q = @vehicle_filter.vehicle_journeys.search( @vehicle_filter.filtered_params)
    @vehicle_journeys ||= @q.result( :distinct => true ).order( "vehicle_journey_at_stops.departure_time").paginate(:page => params[:page], :per_page => 8)
  end

  def adapted_params
    params.tap do |adapted_params|
      adapted_params.merge!( :route => parent)
      hour_entry = "vehicle_journey_at_stops_departure_time_gt(4i)".to_sym
      if params[:q] && params[:q][ hour_entry]
        adapted_params[:q].merge! hour_entry => (params[:q][ hour_entry].to_i - utc_offset)
      end
    end
  end
  def utc_offset
    # Ransack Time eval - utc eval
    sample = [2001,1,1,10,0]
    Time.zone.local(*sample).utc.hour - Time.utc(*sample).hour
  end

  def matrix
    {}.tap do |hash|
      Chouette::VehicleJourney.find( @vehicle_journeys.map { |v| v.id } ).
        each do |vj|
        vj.vehicle_journey_at_stops.each do |vjas|
          hash[ "#{vj.id}-#{vjas.stop_point_id}"] = vjas
        end
      end
    end
  end


  private

  def vehicle_journey_params
    params.require(:vehicle_journey).permit( { footnote_ids: [] } , :journey_pattern_id, :number, :published_journey_name, :published_journey_identifier, :comment, :transport_mode_name, :mobility_restricted_suitability, :flexible_service, :status_value, :facility, :vehicle_type_identifier, :objectid, :time_table_tokens, { date: [ :hour, :minute ] }, :button, :referential_id, :line_id, :route_id, :id, { vehicle_journey_at_stops_attributes: [ :arrival_time, :id, :_destroy, :stop_point_id, :departure_time ] } )
  end

end
