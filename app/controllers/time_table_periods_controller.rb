class TimeTablePeriodsController < ChouetteController
  defaults :resource_class => Chouette::TimeTablePeriod, :collection_name => 'periods'

  respond_to :html

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable
  end

  def update     
    update! do |success, failure|
      success.html { redirect_to referential_time_table_path(@referential,@time_table) }
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to referential_time_table_path(@referential,@time_table) }
    end
  end
  
  def destroy     
    destroy! do |success, failure|
      success.html { redirect_to referential_time_table_path(@referential,@time_table) }
    end
  end
end
