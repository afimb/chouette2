class VehicleJourneysController < ChouetteController
  defaults :resource_class => Chouette::VehicleJourney

  respond_to :js, :only => [:select_journey_pattern, :edit]

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

  def update
    update!(:alert => "Hey pb")
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
