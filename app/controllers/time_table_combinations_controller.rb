class TimeTableCombinationsController < ChouetteController
  respond_to :js, :only => [:create]

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable 
  end

  def create
    @time_table_combination = TimeTableCombination.new( params[:time_table_combination].merge( :source_id => parent.id))
    #@time_table = parent
    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    if @time_table_combination.valid?
      begin
        @time_table = @time_table_combination.combine
        flash[:notice] = t('time_table_combinations.success')
        render "create_success"
      rescue Exception=> e
        Rails.logger.error "Error: #{e}"
        flash[:error] = t('time_table_combinations.failure')
        render "create_failure"
      end
    end

  end
  protected

  alias_method :time_table_combination, :resource
  
end
