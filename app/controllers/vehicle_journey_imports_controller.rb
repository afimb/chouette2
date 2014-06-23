class VehicleJourneyImportsController < ChouetteController
  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  
  actions :new, :create
  respond_to :html, :only => :new
  
  def new    
    @vehicle_journey_import = VehicleJourneyImport.new(:route => route)
    flash[:notice] =  "A CSV or Excel file can be used to import records. The first row should be the column name. 
<p>
The following columns are allowed :
<ul>
  <li>
    <strong>stop_point_id</strong> -
    Integer type
  </li>
  <li>
    <strong>stop_area_name</strong> -
    String type
  </li>
  <li>
    <strong>published_journey_name </strong> -
    String type
  </li>
  <li>
    <strong>published_journey_name </strong> -
    String type ....
  </li>
</ul>
</p>"
    new!
  end

  def create
    @vehicle_journey_import = VehicleJourneyImport.new(params[:vehicle_journey_import].merge({:route => route}))
    if @vehicle_journey_import.save
      redirect_to referential_line_route_path( @referential, @line, @route ), notice: "Import successful" 
    else
      render :new 
    end
  end

  protected 
  alias_method :route, :parent

end
