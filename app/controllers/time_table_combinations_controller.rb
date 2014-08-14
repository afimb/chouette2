class TimeTableCombinationsController < ChouetteController
  respond_to :js, :only => [:create]

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable 
  end

  def create
    @time_table_combination = TimeTableCombination.new( params[:time_table_combination].merge( :source_id => parent.id))
    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    if @time_table_combination.valid?
      begin
        @time_table_combination.combine
        flash[:notice] = t('time_table_combinations.success')
      rescue
        flash[:error] = t('time_table_combinations.failure')
      end
      parent.reload
    end

  end
  protected

  alias_method :time_table_combination, :resource
  
end
