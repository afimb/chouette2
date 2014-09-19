class GroupOfLinesController < ChouetteController
  defaults :resource_class => Chouette::GroupOfLine
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :kml, :only => :show
  respond_to :js, :only => :index

  belongs_to :referential

  def show
    @map = GroupOfLineMap.new(resource).with_helpers(self)
    @lines = resource.lines.order(:name).paginate(:page => params[:page])
    show! do
      build_breadcrumb :show
    end
  end

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
  

  def name_filter
    respond_to do |format|  
      format.json { render :json => filtered_group_of_lines_maps}  
    end  
  end

  protected

  def filtered_group_of_lines_maps
    filtered_group_of_lines.collect do |group_of_line|
      { :id => group_of_line.id, :name => group_of_line.name }
    end
  end
  
  def filtered_group_of_lines
    referential.group_of_lines.select{ |t| t.name =~ /#{params[:q]}/i  }
  end

  def collection    
    @q = referential.group_of_lines.search(params[:q])
    @group_of_lines ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page])
  end

  def resource_url(group_of_line = nil)
    referential_group_of_line_path(referential, group_of_line || resource)
  end

  def collection_url
    referential_group_of_lines_path(referential)
  end
end
