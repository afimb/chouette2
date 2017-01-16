class TimebandsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::Timeband

  respond_to :html

  belongs_to :referential

  def new
    new! do
      build_breadcrumb :new
    end
  end

  private

  def timeband_params
    params.require(:timeband).permit( :name, :start_time, :end_time )
  end
end
