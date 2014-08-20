class VehicleTranslationsController < ChouetteController
  respond_to :js, :only => [:new, :create]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route do
        belongs_to :vehicle_journey, :parent_class => Chouette::VehicleJourney
      end
    end
  end

  def new
    @vehicle_translation = VehicleTranslation.new( :vehicle_journey_id => parent.id)
    flash[:notice] = "mokmlklmk"
    render :action => :new
  end

  def create
    begin
      @vehicle_translation = VehicleTranslation.new( params[:vehicle_translation].merge( :vehicle_journey_id => parent.id))
      @vehicle_translation.translate
      flash[:notice] = t('vehicle_translations.success', :count => @vehicle_translation.count)
    rescue
      flash[:alert] = t('vehicle_translations.failure')
    end
    render :action => :new
  end

end
