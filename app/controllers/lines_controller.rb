class LinesController < ChouetteController
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
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
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
      { :id => line.id, :name => line.published_name }
    end
  end

  def filtered_lines
    referential.lines.select{ |t| t.published_name =~ /#{params[:q]}/i  }
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

    @q = referential.lines.search(params[:q])
    @lines ||= @q.result(:distinct => true).order(:number).paginate(:page => params[:page]).includes([:network, :company])
  end

  private

  def line_params
    params.require(:line).permit( :transport_mode, :network_id, :company_id, :objectid, :object_version, :creation_time, :creator_id, :name, :number, :published_name, :transport_mode_name, :registration_number, :comment, :mobility_restricted_suitability, :int_user_needs, :flexible_service, :group_of_lines, :group_of_line_ids, :group_of_line_tokens, :url, :color, :text_color, { footnotes_attributes: [ :code, :label, :_destroy, :id ] } )
  end

end
