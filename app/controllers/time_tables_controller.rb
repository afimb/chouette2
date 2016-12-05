class TimeTablesController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :tags]

  include TimeTablesHelper
  defaults :resource_class => Chouette::TimeTable
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :js, :only => :index

  belongs_to :referential

  def show

    @year = params[:year] ? params[:year].to_i : Date.today.cwyear
    @time_table_combination = TimeTableCombination.new
    show! do
      build_breadcrumb :show
    end
  end

  def new
    @autocomplete_items = ActsAsTaggableOn::Tag.all
    new! do
      build_breadcrumb :new
    end
  end

  def edit
    edit! do
      build_breadcrumb :edit
      @autocomplete_items = ActsAsTaggableOn::Tag.all
    end
  end

  def index
    request.format.kml? ? @per_page = nil : @per_page = 12

    index! do |format|
      format.html {
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
        build_breadcrumb :index
      }
    end
  end

  def duplicate
    @time_table = Chouette::TimeTable.find params[:id]
    # prepare breadcrumb before prepare data for new timetable
    build_breadcrumb :edit
    @time_table = @time_table.duplicate
    render :new
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:tag]}%")
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.id, :name => t.name }} }
    end
  end

  protected

  def collection
    ransack_params = params[:q]
    # Hack to delete params can't be used by ransack
    tag_search = ransack_params["tag_search"].split(",").collect(&:strip) if ransack_params.present? && ransack_params["tag_search"].present?
    ransack_params.delete("tag_search") if ransack_params.present?

    selected_time_tables = tag_search ? select_time_tables.tagged_with(tag_search, :wild => true, :any => true) : select_time_tables
    @q = selected_time_tables.search(ransack_params)
    @time_tables ||= @q.result(:distinct => true).order(:comment).page(params[:page])
  end

  def select_time_tables
    if params[:route_id]
      referential.time_tables.joins( vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
   else
      referential.time_tables
   end
  end

  def resource_url(time_table = nil)
    referential_time_table_path(referential, time_table || resource)
  end

  def collection_url
    referential_time_tables_path(referential)
  end

  private

  def time_table_params
    params.require(:time_table).permit( :objectid, :object_version, :creation_time, :creator_id, :version, :comment, :int_day_types, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date, { :dates_attributes => [:date, :in_out, :id, :_destroy] }, { :periods_attributes => [:period_start, :period_end, :_destroy, :id] }, :tag_list, :tag_search )
  end
end
