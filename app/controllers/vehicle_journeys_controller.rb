class VehicleJourneysController < ChouetteController
  defaults :resource_class => Chouette::VehicleJourney

  respond_to :js, :only => [:select_journey_pattern, :edit, :new]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  def timeless
    @vehicle_journeys = parent.vehicle_journeys.timeless
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

  def new
    @vehicle_journey = Chouette::VehicleJourney.new( :route => @route)
    @vehicle_journey.update_journey_pattern( parent.journey_patterns.first) if parent.journey_patterns.first

    new!
  end

  protected
  
  alias_method :vehicle_journey, :resource

  def collection
    @q = parent.sorted_vehicle_journeys.search(params[:q])
    @vehicle_journeys ||= @q.result(:distinct => true).order( "vehicle_journey_at_stops.departure_time").paginate(:page => params[:page], :per_page => 10)
    @matrix ||= matrix 
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
end
