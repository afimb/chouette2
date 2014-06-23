class VehicleJourneyExportsController < ChouetteController
  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  
  respond_to :csv, :only => [:new, :index]
  respond_to :xls, :only => [:new, :index]
  
  def new
    new! do |format|
      @vehicle_journey_export = VehicleJourneyExport.new(:route => @route)
      
      format.csv { render text: @vehicle_journey_export.to_csv }
      format.xls { render text: @vehicle_journey_export.to_csv(col_sep: "\t") }
    end
  end

   def index
    index! do |format|
      @vehicle_journey_export = VehicleJourneyExport.new(:route => @route)
      
      format.csv { render text: @vehicle_journey_export.to_csv }
      format.xls { render text: @vehicle_journey_export.to_csv(col_sep: "\t") }
    end
  end
  
  protected 
  alias_method :route, :parent

  def collection
    @vehicle_journey_exports = []
  end
  
end
