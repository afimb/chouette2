class VehicleJourneyImportsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => VehicleJourneyImport

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  actions :new, :create
  respond_to :html, :only => :new

  def new
    @vehicle_journey_import = VehicleJourneyImport.new(:route => route)
    new! do
      build_breadcrumb :new
    end
  end

  def create
    @vehicle_journey_import = VehicleJourneyImport.new( params[:vehicle_journey_import].present? ? params[:vehicle_journey_import].merge({:route => route}) : {:route => route} )
    if @vehicle_journey_import.save
      notice = I18n.t("vehicle_journey_imports.new.success") +
      "<br>" + I18n.t("vehicle_journey_imports.success.created_jp_count",:count => @vehicle_journey_import.created_journey_pattern_count) +
      "<br>" + I18n.t("vehicle_journey_imports.success.created_vj_count",:count => @vehicle_journey_import.created_vehicle_journey_count) +
      "<br>" + I18n.t("vehicle_journey_imports.success.updated_vj_count",:count => @vehicle_journey_import.updated_vehicle_journey_count) +
      "<br>" + I18n.t("vehicle_journey_imports.success.deleted_vj_count",:count => @vehicle_journey_import.deleted_vehicle_journey_count)
      redirect_to referential_line_route_path( @referential, @line, @route ), notice: notice
    else
      flash[:error] = ( [ I18n.t("vehicle_journey_imports.errors.import_aborted")] + @vehicle_journey_import.errors.full_messages).join("<br />").html_safe
      render :new
    end
  end

  protected
  alias_method :route, :parent

end
