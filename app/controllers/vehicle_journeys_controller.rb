class VehicleJourneysController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :select_journey_pattern]

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
  #  update_footnote_on_vehicle_journey_at_stops
    update!(:alert => t('activerecord.errors.models.vehicle_journey.invalid_times'))
  end

  def index
    index! do
      if collection.out_of_range? && params[:page].to_i > 1
        redirect_to url_for params.merge(:page => 1)
        return
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
    unless @vehicle_journeys
      @vehicle_filter = VehicleFilter.new adapted_params
      @vehicle_filter.journey_category_model = resource_class.model_name.route_key
      @q = @vehicle_filter.vehicle_journeys.search @vehicle_filter.filtered_params
      @vehicle_journeys = @q.result( :distinct => false ).page(params[:page]).per(8)
    end
    matrix
    @vehicle_journeys
  end
  alias_method :vehicle_journeys, :collection

  def adapted_params
    params.tap do |adapted_params|
      adapted_params.merge!( :route => parent)
      hour_entry = "vehicle_journey_at_stops_departure_time_gteq(4i)".to_sym
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
    @matrix = resource_class.matrix(@vehicle_journeys)
  end

  ## updates StopPoint Footnotes on StopPoint
  # - this is done outside the regular update since JourneyPattern uses the stop_point change event mechanism
#DISABLED until editing works in GUI
  def update_footnote_on_vehicle_journey_at_stops
    if params[:vehicle_journey_at_stops_attributes][:footnote_ids].present?
      params[:vehicle_journey_at_stops_attributes][:footnote_ids].each do |k, v|
        stop_point_id = v[:id]
        footnote_tokens = v[:footnote_tokens].split(",")
        Chouette::VehicleJourneyAtStop.find(stop_point_id).footnote_ids = footnote_tokens
      end
    end
  end


  private

  def vehicle_journey_params
    params.require(:vehicle_journey).permit( { footnote_ids: [] } , :journey_pattern_id, :number, :published_journey_name,
                                             :published_journey_identifier, :private_code, :comment, :transport_mode_name,:transport_submode,:transport_submode_name,
                                             :service_alteration_name,
                                             :mobility_restricted_suitability, :flexible_service, :status_value,
                                             :facility, :vehicle_type_identifier, :objectid, :time_table_tokens, :footnote_tokens,
                                             { date: [ :hour, :minute ] }, :button, :referential_id, :line_id,
                                             :route_id, :id, { vehicle_journey_at_stops_attributes: [ :arrival_time,
                                                                                                      :id, :_destroy,
                                                                                                      :stop_point_id,
                                                                                                      :departure_time,
                                                                                                      :departure_day_offset,
                                                                                                      :arrival_day_offset,
                                                                                                      :footnote_tokens] },

                                            {flexible_service_properties_attributes: [ :id,:_destroy, :objectid, :flexible_service_type, :cancellation_possible, :change_of_time_possible,  { booking_arrangement_attributes:
                                                                       [:id, :booking_note, :book_when, :booking_access, :minimum_booking_period, :latest_booking_time,
                                                                        {booking_contact_attributes: [:id, :phone,:url,:fax,:email,:contact_person,:further_details]}, :buy_when => [], :booking_methods => [] ]}]}
    )
  end

end
