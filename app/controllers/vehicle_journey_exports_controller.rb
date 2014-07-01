class VehicleJourneyExportsController < ChouetteController
  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  
  respond_to :csv, :only => [:index]
  respond_to :xls, :only => [:index]

  def index
    @column_names = column_names 
    index! do |format|      
      format.csv { send_data VehicleJourneyExport.new(:route => route, :vehicle_journeys => vehicle_journeys, :column_names => column_names).to_csv }
      format.xls
    end
  end
  
  protected
  
  def column_names
    ["stop_point_id", "stop_area_name"] + vehicle_journeys.collect(&:objectid)
  end
    
  alias_method :route, :parent
 
  def collection
    @vehicle_journeys ||= route.vehicle_journeys.includes(:vehicle_journey_at_stops).order("vehicle_journey_at_stops.departure_time")
  end
  alias_method :vehicle_journeys, :collection
  
end
