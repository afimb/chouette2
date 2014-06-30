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
    new!
  end

  def create
    @vehicle_journey_import = VehicleJourneyImport.new( params[:vehicle_journey_import].present? ? params[:vehicle_journey_import].merge({:route => route}) : {:route => route} )
    if @vehicle_journey_import.save
      redirect_to referential_line_route_path( @referential, @line, @route ), notice: I18n.t("vehicle_journey_imports.new.success")
    else
      flash[:error] = I18n.t("stop_area_imports.errors.import_aborted") + "<br>" + @vehicle_journey_import.errors.full_messages.join("<br>")
      render :new 
    end
  end

  protected 
  alias_method :route, :parent

end
