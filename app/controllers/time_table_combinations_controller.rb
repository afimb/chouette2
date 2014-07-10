class TimeTableCombinationsController < ChouetteController
  respond_to :html, :only => [:create]

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable 
  end

  def create
    combination = TimeTableCombination.new( params[:time_table_combination].merge( :source_id => parent.id))
    if combination.invalid?
      flash[:alert] = combination.errors.full_messages.join("<br/>")
    else
      begin
        combination.combine
        flash[:notice] = t('time_table_combinations.success')
      rescue
        flash[:alert] = t('time_table_combinations.failure')
      end
    end
    redirect_to referential_time_table_path(@referential, @time_table)

  end
  
end
