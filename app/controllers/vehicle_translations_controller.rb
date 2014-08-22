class VehicleTranslationsController < ChouetteController
  respond_to :js, :only => [:new, :create]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route do
        belongs_to :vehicle_journey, :parent_class => Chouette::VehicleJourney
      end
    end
  end
  after_filter :clean_flash

  def clean_flash
        # only run this in case it's an Ajax request.
    return unless request.xhr?

    flash.discard
  end

  def new
    @vehicle_translation = VehicleTranslation.new( :vehicle_journey_id => parent.id, :count => 1, :duration => 1)
    render :action => :new
  end

  def create
    @vehicle_translation = VehicleTranslation.new( params[:vehicle_translation].merge( :vehicle_journey_id => parent.id))

    begin
      if @vehicle_translation.valid?
        @vehicle_translation.translate
        flash[:notice] = t('vehicle_translations.success', :count => @vehicle_translation.count)
      else
        flash[:alert] = @vehicle_translation.errors[ :vehicle_journey_id] unless @vehicle_translation.errors[ :vehicle_journey_id].empty?
      end
    rescue => e
      Rails.logger.error( "VehicleTranslation error, @vehicle_translation=#{@vehicle_translation.inspect}")
      Rails.logger.error( e.inspect)
      flash[:alert] = t('vehicle_translations.failure')
    end
    render :action => :new
  end

end
