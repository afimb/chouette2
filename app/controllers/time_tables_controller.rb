class TimeTablesController < ChouetteController
  defaults :resource_class => Chouette::TimeTable
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  protected

  def collection    
    @q = referential.time_tables.search(params[:q])
    @time_tables ||= @q.result(:distinct => true).order(:comment).paginate(:page => params[:page], :per_page => 10)
  end

  def resource_url(time_table = nil)
    referential_time_table_path(referential, time_table || resource)
  end

  def collection_url
    referential_time_tables_path(referential)
  end
end
