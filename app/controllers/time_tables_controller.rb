class TimeTablesController < ChouetteController
  defaults :resource_class => Chouette::TimeTable
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  def comment_filter
    respond_to do |format|  
      format.json { render :json => filtered_time_tables_maps}  
    end  
    
  end

  protected

  def filtered_time_tables_maps
    filtered_time_tables.collect do |time_table|
      { :id => time_table.id, :name => time_table.comment }
    end
  end
  def filtered_time_tables
    referential.time_tables.select{ |t| t.comment =~ /#{params[:q]}/i  }
  end

  def collection    
    @q = referential.time_tables.search(params[:q])
    @time_tables ||= @q.result(:distinct => true).order(:comment).paginate(:page => params[:page])
  end

  def resource_url(time_table = nil)
    referential_time_table_path(referential, time_table || resource)
  end

  def collection_url
    referential_time_tables_path(referential)
  end
end
