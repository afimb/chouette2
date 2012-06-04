class VehicleJourneysController < ChouetteController
  defaults :resource_class => Chouette::VehicleJourney

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  def select_journey_pattern
    if params[:journey_pattern_id]
      @vehicle_journey = vehicle_journey
      @vehicle_journey_at_stops = pseudo_vehicle_journey_at_stops
      puts "@vehicle_journey=#{@vehicle_journey.inspect}"
    end
  end

  def pseudo_vehicle_journey_at_stops
    vjas_by_sp_id = {}.tap do |hash|
      @vehicle_journey.vehicle_journey_at_stops.each do |vjas|
        hash.merge!( vjas.stop_point_id => vjas)
      end
    end
    [].tap do |vjas_array|
      @selected_journey_pattern.stop_points.each do |sp|
        if vjas_by_sp_id.include?( sp.id)
          vjas_array << vjas_by_sp_id[ sp.id]
        else
          vjas_array << @vehicle_journey.vehicle_journey_at_stops.build( :stop_point_id => sp.id)
        end
      end
    end
  end


  protected
  
  alias_method :vehicle_journey, :resource

  def collection
    @q = parent.vehicle_journeys.search(params[:q])
    @vehicle_journeys ||= @q.result(:distinct => true).paginate(:page => params[:page], :per_page => 10)
    @matrix ||= matrix 
  end

  def matrix
    {}.tap do |hash|
      @vehicle_journeys.each do |vj|
        vj.vehicle_journey_at_stops.each do |vjas|
          hash[ "#{vj.id}-#{vjas.stop_point_id}"] = vjas 
        end
      end
    end
  end
end
