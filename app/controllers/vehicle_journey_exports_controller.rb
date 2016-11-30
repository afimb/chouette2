class VehicleJourneyExportsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end

  respond_to :csv, :only => [:index]
  respond_to :zip, :only => [:index]
  #respond_to :xls, :only => [:index]

  def index
    index! do |format|
      format.csv { send_data VehicleJourneyExport.new(:route => route, :vehicle_journeys => vehicle_journeys, :vehicle_journey_frequencies => vehicle_journey_frequencies).to_csv(:col_sep => ";") , :filename => t("vehicle_journey_exports.new.basename")+"_#{route.id}.csv" }
      format.zip do
        begin
          temp_file = Tempfile.new("vehicle_journey_export")
          VehicleJourneyExport.new(:route => route, :vehicle_journeys => vehicle_journeys, :vehicle_journey_frequencies => vehicle_journey_frequencies).to_zip(temp_file,:col_sep => ";")
          send_data  File.read(temp_file.path), :filename => t("vehicle_journey_exports.new.basename")+"_#{route.id}.zip"
        ensure
          temp_file.close
          temp_file.unlink
        end
      end
      #format.xls
    end
  end

  protected


  alias_method :route, :parent

  def collection
    @vehicle_journeys ||= route.vehicle_journeys.includes(:vehicle_journey_at_stops).order("vehicle_journey_at_stops.departure_time")
  end
  alias_method :vehicle_journeys, :collection

  def vehicle_journey_frequencies
    @vehicle_journey_frequencies ||= route.vehicle_journey_frequencies.includes(:journey_frequencies).order("journey_frequencies.first_departure_time")
  end

end
