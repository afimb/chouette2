class LinesController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :name_filter]

  defaults :resource_class => Chouette::Line
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

  def index
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

  def show
    @map = LineMap.new(resource).with_helpers(self)
    @routes = @line.routes
    @group_of_lines = @line.group_of_lines
    show! do
      build_breadcrumb :show
    end
  end

  # overwrite inherited resources to use delete instead of destroy
  # foreign keys will propagate deletion)
  def destroy_resource(object)
    object.delete
  end

  def delete_all
    objects =
      get_collection_ivar || set_collection_ivar(end_of_association_chain.where(:id => params[:ids]))
    objects.each { |object| object.delete }
    respond_with(objects, :location => smart_collection_url)
  end

  def name_filter
    respond_to do |format|
      format.json { render :json => filtered_lines_maps}
    end

  end

  protected

  def filtered_lines_maps
    filtered_lines.collect do |line|
      { :id => line.id, :name => (line.published_name ? line.published_name : line.name) }
    end
  end

  def filtered_lines
    referential.lines.select{ |t| [t.name, t.published_name].find { |e| /#{params[:q]}/i =~ e }  }
  end

  def collection
    if params[:q] && params[:q]["network_id_eq"] == "-1"
      params[:q]["network_id_eq"] = ""
      params[:q]["network_id_blank"] = "1"
    end

    if params[:q] && params[:q]["company_id_eq"] == "-1"
      params[:q]["company_id_eq"] = ""
      params[:q]["company_id_blank"] = "1"
    end

    if params[:q] && params[:q]["group_of_lines_id_eq"] == "-1"
      params[:q]["group_of_lines_id_eq"] = ""
      params[:q]["group_of_lines_id_blank"] = "1"
    end

    if params[:q] && params[:q]["transport_mode_name_eq"] == "unkown"
      params[:q]["transport_mode_name_eq"] = ""
      params[:q]["transport_mode_name_blank"] = "1"
    end

    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).page(params[:page]).includes([:network, :company])
  end

  private

  def line_params
    params.require(:line).permit( :transport_mode, :transport_submode, :network_id, :company_id, :objectid,
    :object_version, :creation_time, :creator_id, :name, :number, :published_name,
    :transport_mode_name, :transport_submode_name, :registration_number, :comment,
    :mobility_restricted_suitability, :int_user_needs, :flexible_service, :group_of_lines,
    :group_of_line_ids, :group_of_line_tokens, :url, :color, :text_color, :stable_id,
    :footnote_ids, :footnote_tokens, :flexible_line_type,{ booking_arrangement_attributes:
      [:id, :booking_note, :book_when, :booking_access, :minimum_booking_period, :latest_booking_time,
       {booking_contact_attributes: [:id, :phone,:url,:fax,:email,:contact_person,:further_details]}, :buy_when => [], :booking_methods => [] ] })
  end

end
