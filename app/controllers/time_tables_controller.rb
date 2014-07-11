class TimeTablesController < ChouetteController
  include TimeTablesHelper
  defaults :resource_class => Chouette::TimeTable
  respond_to :html
  respond_to :xml
  respond_to :json

  belongs_to :referential

  def show
    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    show!
  end

  def comment_filter
    respond_to do |format|  
      format.json { render :json => filtered_time_tables_maps}  
    end  
    
  end

  def index    
    request.format.kml? ? @per_page = nil : @per_page = 12

    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      }
    end       
  end

  def duplicate
    @time_table = Chouette::TimeTable.find params[:id]
    @time_table = @time_table.duplicate
    @time_table.save
    flash[:notice] = I18n.translate("time_tables.duplicate_success")
    redirect_to edit_referential_time_table_path(@referential, @time_table)
  end


  protected

  def filtered_time_tables_maps
    filtered_time_tables.collect do |time_table|
      { :id => time_table.id, :name => time_table_description(time_table) }
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
