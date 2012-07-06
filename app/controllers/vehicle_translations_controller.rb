class VehicleTranslationsController < ChouetteController
  respond_to :html, :only => [:create]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route do
        belongs_to :vehicle_journey, :parent_class => Chouette::VehicleJourney
      end
    end
  end

  def create
    begin
      translation = VehicleTranslation.new( params[:vehicle_translation].merge( :vehicle_journey_id => parent.id))
      translation.translate
      flash[:notice] = t('vehicle_translations.success', :count => translation.count)
    rescue
      flash[:alert] = t('vehicle_translations.failure')
    end
    redirect_to referential_line_route_vehicle_journeys_path(@referential, @line, @route)

  end
  
end
