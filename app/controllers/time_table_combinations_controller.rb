class TimeTableCombinationsController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  respond_to :js, :only => [:new,:create]

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable
  end
  after_filter :clean_flash

  def clean_flash
    # only run this in case it's an Ajax request.
    return unless request.xhr?
    flash.discard
  end

  def new
    @time_table_combination = TimeTableCombination.new(:source_id => parent.id)
    render :action => :new
  end


  def create
    Rails.logger.warn( params.inspect)
    @time_table_combination = TimeTableCombination.new( params[:time_table_combination].merge( :source_id => parent.id))
    Rails.logger.warn( @time_table_combination.inspect)
    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    if @time_table_combination.valid?
      begin
        @time_table = @time_table_combination.combine
        flash[:notice] = t('time_table_combinations.success')
        render "create_success"
      rescue => e
        Rails.logger.error( "TimeTableCombination error, @time_table_combination=#{@time_table_combination.inspect}")
        Rails.logger.error( e.inspect)
        flash[:error] = t('time_table_combinations.failure')
        render "create_failure"
      end
    else
      render "create_failure"
    end

  end
  protected

  alias_method :time_table_combination, :resource

end
